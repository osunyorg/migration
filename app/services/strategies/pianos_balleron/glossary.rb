class Strategies::PianosBalleron::Glossary < Strategies::Base

  def osuny_api_instance
    @osuny_api_instance ||= OsunyApi::CommunicationWebsitePortfolioProjectApi.new
  end

  def apply_to_page
    log "Titre #{@page.title}"
    log "Identifiant de migration #{@page.migration_identifier}"
    json = json(@page)
    log json
  end

  protected

  def json(page)
    {
      title: @page.title,
      migration_identifier: page.migration_identifier
    }
  end
end
