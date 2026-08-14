class Strategies::PianosBalleron::Glossary < Strategies::Base

  def apply_to_page
    log "---"
    log "Titre “#{page.title}”"
    log "Identifiant de migration ”#{page.migration_identifier}”"
    log "Site osuny ”#{website.osuny_website_id}”"
    log "Cible osuny ”#{group.osuny_target_id}”"
    json = json(@page)
    log "Données JSON"
    log JSON.pretty_generate(json)
    return if dry_run
    begin
    osuny_api.communication_websites_website_id_pages_upsert_post_with_http_info(
      website.osuny_website_id,
      {
        body: {
          pages: [json]
        },
        return_type: 'Object'
      }
    )
    rescue error
      log error
    end
  end

  protected

  def osuny_api
    @osuny_api ||= OsunyApi::CommunicationWebsitePageApi.new(website.osuny_api_client)
  end

  def json(page)
    {
      migration_identifier: page.migration_identifier,
      parent_id: group.osuny_target_id,
      localizations: {
        "#{page.language.iso_code}": {
          title: title,
          migration_identifier: "#{page.migration_identifier}-#{page.language.iso_code}",
          published: true,
          meta_description: meta_description,
          featured_image: {
            url: featured_image_url
          },
          blocks: [
            {
              migration_identifier: "#{page.migration_identifier}-#{page.language.iso_code}-chapter",
              template_kind: 'chapter',
              data: {
                text: chapter
              }
            }
          ]
        }
      }
    }
  end

  def title
    page.nokogiri.css('h1').first.text
  end

  def meta_description
    page.nokogiri.css('meta[name="description"]').first['content']
  end
  
  def chapter
    @chapter ||= begin
      text = page.nokogiri.css('p').first.to_html
      text.gsub!('<a href="http://" target="_blank" rel="nofollow"></a>', '')
      text.gsub!("\r\n", '')
      text.gsub!('<br><br></p>', '</p>')
      text.gsub!('<br></p>', '</p>')
      text
    end
    @chapter
  end

  def featured_image_url
    page.website.url +
    page.nokogiri.css('.produit_background img')[0]['src']
  end
end
