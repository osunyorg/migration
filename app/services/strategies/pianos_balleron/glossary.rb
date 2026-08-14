class Strategies::PianosBalleron::Glossary < Strategies::Base

  def apply_to_page
    log "Titre #{@page.title}"
    log "Identifiant de migration #{@page.migration_identifier}"
  end

end
