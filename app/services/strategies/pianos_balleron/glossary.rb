class Strategies::PianosBalleron::Glossary < Strategies::Base

  def hint
    <<~HTML
      <p>Dans les réglages JSON, indiquer la page du lexique</p>
      <pre>
      {
        "parent": "UUID"
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
    log "Identifiant de migration ”#{page.migration_identifier}”"
    log "Site osuny ”#{website.osuny_website_id}”"
    log "Parent ”#{parent_id}”"
    json = json(page)
    log "Données JSON"
    log json
    return if dry_run
    osuny_api.communication_websites_website_id_pages_upsert_post_with_http_info(
      website.osuny_website_id,
      {
        body: {
          pages: [json]
        },
        return_type: 'Object'
      }
    )
    page.migrated!
  end

  protected

  def osuny_api
    @osuny_api ||= OsunyApi::CommunicationWebsitePageApi.new(website.osuny_api_client)
  end

  def json(page)
    {
      migration_identifier: root_page_identifier,
      parent_id: parent_id,
      localizations: {
        "#{page.language.osuny_iso_code}": {
          title: title,
          migration_identifier: "#{root_page_identifier}-#{page.language.iso_code}",
          published: true,
          meta_description: meta_description,
          featured_image: {
            url: featured_image_url
          },
          aliases: [
            { path: page.path }
          ],
          blocks: [
            {
              migration_identifier: "#{root_page_identifier}-#{page.language.iso_code}-chapter",
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

  def parent_id
    setting(:parent)
  end

  def chapter
    @chapter = page.nokogiri.css('p').first.to_html
    @chapter.gsub!('<a href="http://" target="_blank" rel="nofollow"></a>', '')
    @chapter.gsub!("\r\n", '')
    @chapter.gsub!('<br><br></p>', '</p>')
    @chapter.gsub!('<br></p>', '</p>')
    @chapter
  end

  def featured_image_url
    page.website.url +
    page.nokogiri.css('.produit_background img')[0]['src']
  end
end
