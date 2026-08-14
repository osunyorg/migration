class Strategies::PianosBalleron::Pianos < Strategies::Base

  def hint
    <<~HTML
      <p>Dans les réglages JSON, indiquer les catégories</p>
      <pre>
      {
        "category_selling": "UUID",
        "category_sold": "UUID"
      }
      </pre>
    HTML
  end

  def apply_to_page
    if title.empty?
      log 'Le titre est vide, on passe'
      return
    end
    log "---"
    log "Titre “#{title}”"
    json = json(@page)
    log "Données JSON"
    log json
    return if dry_run
    osuny_api.communication_websites_website_id_portfolio_projects_upsert_post_with_http_info(
      website.osuny_website_id,
      {
        body: {
          projects: [json]
        },
        return_type: 'Object'
      }
    )
    page.migrated!
  end

  protected

  def osuny_api
    @osuny_api ||= OsunyApi::CommunicationWebsitePortfolioProjectApi.new(website.osuny_api_client)
  end

  def json(page)
    {
      migration_identifier: root_page_identifier,
      year: project_year,
      category_ids: category_ids,
      localizations: {
        "#{page.language.osuny_iso_code}": {
          title: title,
          subtitle: subtitle,
          summary: summary,
          migration_identifier: "#{root_page_identifier}-#{page.language.iso_code}",
          published: true,
          meta_description: meta_description,
          featured_image: {
            url: featured_image_url
          },
          aliases: [
            { path: page.path }
          ],
          blocks: blocks
        }
      }
    }
  end

  def blocks
    @blocks = []
    @blocks << block_datatable
    @blocks << block_gallery if block_gallery?
    @blocks << block_video if block_video?
    @blocks
  end

  # Piano Bosendorfer 1915
  def title
    @title = page.nokogiri.css('h1').first.text
    @title += " #{piano_year}" if piano_year
    @title
  end

  def piano_year
    page.nokogiri.css('h2').first.text
      .gsub('Piano de ', '')
      .gsub('Piano of ', '')
      .gsub('のピアノ ', '')
  end

  def project_year
    extract_between('<em><b>Piano restauré en :</b>', '</em>') ||
    2026
  end

  def subtitle
    piano_reference || ''
  end

  # <br><em><b>Référence :</b> R016</em>
  def piano_reference
    extract_between('<em><b>Référence :</b>', '</em>') ||
    extract_between('<em><b>Reference :</b>', '</em>') ||
    extract_between('<em><b>参照 :</b>', '</em>')
  end

  def summary
    description = extract_between '<em><b>Description :</b>', '</em>'
    "<p>#{description}</p>"
  end

  def featured_image_url
    page.website.url +
    page.nokogiri.css('.produit_background img')[0]['src']
  end

  # Catégorie

  def sold?
    page.html.include?('Piano vendu') ||
    page.html.include?('Piano sold')
  end

  def category_ids
    [
      (sold? ? setting(:category_sold) : setting(:category_selling))
    ]
  end

  # Tableau

  def block_datatable
    {
      migration_identifier: "#{root_page_identifier}-#{page.language.iso_code}-datatable",
      template_kind: 'datatable',
      data: {
        elements: datatable_elements,
        alphabetical: false,
        caption: '',
        columns:['',''],
      }
    }
  end

  def datatable_elements
    elements = []
    page.nokogiri.css('.produit_fiche em').each do |em|
      next if em.text.blank?
      key = em.children.first.text.gsub(' :', '').lstrip.rstrip
      next if key.in?([
        'Référence', 'Reference',
        'Description',
        'Vidéo'
      ])
      value = em.children.last.text.lstrip.rstrip
      next if value.empty?
      elements << { cells:[key, value] }
    end
    elements
  end

  # Galerie de photos

  def block_gallery
    {
      migration_identifier: "#{root_page_identifier}-#{page.language.iso_code}-gallery",
      template_kind: 'gallery',
      data: {
        layout: 'carousel',
        elements: gallery_elements
      }
    }
  end

  def block_gallery?
    page.nokogiri.css('.produit_fiche img').any?
  end

  def gallery_elements
    elements = []
    page.nokogiri.css('.produit_fiche img').each do |img|
      image_relative_url = img[:src]
      image_url = website.url + image_relative_url
      media = get_media(image_url)
      if media
        image_data = {
          id: media.osuny_active_storage_blob_id,
          filename: media.osuny_active_storage_blob_filename,
          signed_id: media.osuny_active_storage_blob_signed_id
        }
      else
        image_data = { id: "NEW_MEDIA", filename: "...", signed_id: "..." }
      end
      elements << {
        image: image_data,
        alt: '',
        credit: '<p>Pianos Balleron</p>',
        text: ''
      }
    end
    elements
  end

  # Vidéo

  def block_video
    {
      migration_identifier: "#{root_page_identifier}-#{page.language.iso_code}-video",
      template_kind: 'video',
      data: {
        layout: 'player',
        url: video_url
      }
    }
  end

  def block_video?
    video_url.present?
  end

  def video_url
    return if video_id.nil?
    "https://www.youtube.com/watch?v=#{video_id}"
  end

  def video_id
    extract_between('"https://www.youtube.com/embed/', '"')
  end

  # Utilitaires

  def extract_between(fragment_start, fragment_end)
    parts = page.html.split(fragment_start)
    return if parts.one?
    parts = parts.second.split(fragment_end)
    parts.first.lstrip.rstrip
  end

  def get_media(image_url)
    media = website.medias.where(url: image_url).first_or_initialize
    return if dry_run && media.new_record?
    media.save! if media.new_record?
    media.sync_to_osuny!
    media
  end
end
