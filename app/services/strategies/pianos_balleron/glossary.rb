class Strategies::PianosBalleron::Glossary < Strategies::Base

  def apply_to_page
    log @page.title
    log @page.migration_identifier
    log @page.html
  end

end
