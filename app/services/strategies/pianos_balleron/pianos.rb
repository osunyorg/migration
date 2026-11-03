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
    page_parser = Strategies::PianosBalleron::Pianos::PageParser.new(
      page,
      {
        root_page_identifier: root_page_identifier,
        meta_description: meta_description,
        category_sold: setting(:category_sold),
        category_selling: setting(:category_selling),
        dry_run: dry_run
      }
    )
    if page_parser.title.blank?
      log "Le titre est vide, on passe"
      return
    end
    if page_parser.project_year.blank?
      log "L'année du projet n'est pas identifiable, on passe"
      return
    end
    log "---"
    log "Titre “#{page_parser.title}”"
    log "Année du projet “#{page_parser.project_year}”"
    json = page_parser.to_json
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
end
