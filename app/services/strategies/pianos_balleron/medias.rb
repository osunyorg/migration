class Strategies::PianosBalleron::Medias < Strategies::Base

  def hint
    <<~HTML
      <p>Dans les réglages JSON, indiquer la catégorie</p>
      <pre>
      {
        "category": "UUID"
      }
      </pre>
    HTML
  end

  def apply_to_page
    list = page.nokogiri.css('.parutions a')
    list.reverse.each_with_index do |element, index|
      create_post(element, index)
    end
    return if dry_run
    page.migrated!
  end

  protected

  def osuny_api
    @osuny_api ||= OsunyApi::CommunicationWebsitePostApi.new(website.osuny_api_client)
  end

  def create_post(element, index)
    log '---'
    title = element.css('b').first.text.lstrip.rstrip
    title = title.gsub(' ©PianosBalleron', '')
    log title
    migration_identifier = "#{root_page_identifier}-#{index}"
    category_ids = [setting(:category)]
    featured_image_data = featured_image_data_for_element(element)
    published_at = convert_date(element.css('i').first.text)
    json = {
      migration_identifier: migration_identifier,
      category_ids: category_ids,
      localizations: {
        "#{page.language.osuny_iso_code}": {
          title: title,
          migration_identifier: "#{migration_identifier}-#{page.language.iso_code}",
          published: true,
          published_at: published_at,
          featured_image: featured_image_data
        }
      }
    }
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
  end

  # - 2024 -
  def convert_date(date)
    date = date.gsub('-', '').lstrip.rstrip
    Date.new(date.to_i)
  end

  def featured_image_data_for_element(element)
    featured_image_url = page.website.url + element.css('img').first['src']
    return unless featured_image_url.present?
    media = get_website_media_from_url(featured_image_url)
    blob_id = media ? media.osuny_active_storage_blob_id : "NEW_MEDIA"
    { blob_id: blob_id }
  end
end
