class Strategies::SchonMagazine::Posts < Strategies::Base
  def hint
    <<~HTML
      <p>Dans les réglages JSON, indiquer les catégories</p>
      <pre>
      {
        "category_ids": {
          "arts-and-culture": ["UUID", "UUID"],
          "beauty": ["UUID", "UUID"],
          "editorial": ["UUID", "UUID"],
          "fab-collab": ["UUID", "UUID"],
          "fashion": ["UUID", "UUID"],
          "interview": ["UUID", "UUID"],
          "meta-buzz": ["UUID", "UUID"],
          "meta-get-ready": ["UUID", "UUID"],
          "meta-reflection": ["UUID", "UUID"],
          "metaverse": ["UUID", "UUID"],
          "on-the-cover": ["UUID", "UUID"],
          "spotlight": ["UUID", "UUID"],
          "style": ["UUID", "UUID"],
          "unique-travel": ["UUID", "UUID"]
        }
      }
      </pre>
    HTML
  end

  def apply_to_page
    if title.blank?
      log "Le titre est vide, on passe"
      return
    end
    if published_at.blank?
      log "La date de publication n'est pas identifiable, on passe"
      return
    end
    log "---"
    log "Titre “#{title}”"
    log "Date de publication “#{published_at}”"
    json = json(page)
    log "Données JSON"
    log json
    return if dry_run
    osuny_api.communication_websites_website_id_posts_upsert_post_with_http_info(
      website.osuny_website_id,
      {
        body: {
          posts: [json]
        },
        return_type: 'Object'
      }
    )
    page.migrated!
  end

  protected

  def osuny_api
    @osuny_api ||= OsunyApi::CommunicationWebsitePostApi.new(website.osuny_api_client)
  end

  def json(page)
    {
      migration_identifier: root_page_identifier,
      category_ids: category_ids,
      localizations: {
        "#{page.language.osuny_iso_code}": {
          migration_identifier: "#{root_page_identifier}-en",
          title: title,
          featured_image: featured_image_data,
          meta_description: meta_description,
          published: true,
          published_at: published_at,
          slug: slug,
          summary: "<p>#{summary}</p>", # To be confirmed
          aliases: [
            { path: page.path }
          ],
          blocks: blocks
        }
      }
    }
  end

  def title
    @title ||= page.nokogiri.css('h1').first.text
  end

  def meta_description
    return @meta_description if defined?(@meta_description)
    element = page.nokogiri.css('meta[name="description"]').first
    element ||= page.nokogiri.css('meta[property="og:description"]').first
    return if element.nil?
    @meta_description = element['content']
  end

  def published_at
    return @published_at if defined?(@published_at)
    element = page.nokogiri.css('meta[property="article:published_time"]').first
    return if element.nil?
    date_string = element['content']
    @published_at = Time.parse(date_string) rescue nil
  end

  def slug
    @slug ||= case page.path
              when "/%e2%88%9e/"
                "infinity"
              when "/%d0%b7o%d0%bbo%d1%82a%d1%8f-%d0%b1a%d0%b1azolotaya-baba-golden-woman/"
                "baba-golden-woman"
              else
                page.path.gsub('/', '')
              end
  end

  def summary
    @summary ||= begin
      text_containers = page.nokogiri.css('.schon-article-header .et_pb_post_title ~ div')
      texts = text_containers.map { |text_container| text_container.text.strip }
      texts.join("<br>")
    end
  end

  def featured_image_data
    return unless featured_image_blob_id
    { blob_id: featured_image_blob_id }
  end

  def featured_image_blob_id
    return unless featured_image_url.present?
    @featured_image_blob_id ||= begin
      media = get_website_media_from_url(featured_image_url)
      media ? media.osuny_active_storage_blob_id
            : "NEW_MEDIA"
    end
  end

  def featured_image_url
    element = page.nokogiri.css('meta[property="og:image"]').first
    return if element.nil?
    element['content']
  end

  def legacy_category_slugs
    @legacy_category_slugs ||= page.nokogiri.css('.schon-article-header a[href^="https://schon.ch/category/"]').map do |element|
      element['href'].split('/').last
    end
  end

  def category_ids
    legacy_category_slugs.map { |slug|
      setting(:category_ids).fetch(slug, [])
    }.flatten.uniq
  end

  def blocks
    @blocks ||= begin
      blocks = []
      content = page.nokogiri.css('.et_pb_post_content').first
      return blocks if content.nil?
      # [
      #   ["wp-block-paragraph", [<element1>, <element2>, ...]],
      #   ["wp-block-image", [<element1>, <element2>, ...]],
      #   ["wp-block-paragraph", [<element1>, <element2>, ...]],
      #   ...
      # ]
      grouped_children = content.element_children.chunk { |element|
        class_names = element['class'] || ''
        class_names.split(' ').detect { |class_name| class_name.start_with?('wp-block-') }
      }.to_a
      grouped_children.each_with_index do |(block_type, elements), index|
        case block_type
        when 'wp-block-paragraph'
          blocks << chapter_block_from_elements(elements, index)
        when 'wp-block-image'
          blocks << gallery_block_from_elements(elements, index)
        else
          puts "Unknown block type: #{block_type}"
        end
      end
      blocks
    end
  end

  def chapter_block_from_elements(elements, index)
    {
      migration_identifier: "#{root_page_identifier}-en-block-#{index}",
      template_kind: "chapter",
      data: {
        text: elements.map { |element| "<p>#{element.inner_html.strip}</p>" }.join
      }
    }
  end

  def gallery_block_from_elements(elements, index)
    {
      migration_identifier: "#{root_page_identifier}-en-block-#{index}",
      template_kind: "gallery",
      data: {
        layout: "grid",
        elements: elements.map { |element|
          image_url = element.css('img').first['src']
          return unless image_url.present?
          media = get_website_media_from_url(image_url)
          image_data = block_image_component_from_media(media)
          caption = element.css('figcaption').first&.inner_html&.strip || ""
          {
            image: image_data,
            text: "<p>#{caption}</p>"
          }
        }.compact
      }
    }
  end

  def block_image_component_from_media(media)
    return { id: "NEW_MEDIA" } unless media
    {
      id: media.osuny_active_storage_blob_id,
      communication_media_id: media.osuny_communication_media_id,
      signed_id: media.osuny_active_storage_blob_signed_id
    }
  end

end
