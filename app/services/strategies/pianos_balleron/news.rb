class Strategies::PianosBalleron::News < Strategies::Base

  FRENCH_MONTHS = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre']

  def apply_to_page
    list = page.nokogiri.css('.actu li')
    list.reverse.each_with_index do |li, index|
      create_post(li, index)
    end
    return if dry_run
    page.migrated!
  end

  protected

  def osuny_api
    @osuny_api ||= OsunyApi::CommunicationWebsitePostApi.new(website.osuny_api_client)
  end

  def create_post(li, index)
    log '---'
    title = li.css('b').first.text.lstrip.rstrip
    log title
    migration_identifier = "#{root_page_identifier}-#{index}"
    text = "<p>#{li.css('p').first.text}</p>"
    featured_image_url = page.website.url + li.css('img').first['src']
    published_at = convert_date(li.css('i').first.text)
    json = {
      migration_identifier: migration_identifier,
      localizations: {
        "#{page.language.osuny_iso_code}": {
          title: title,
          migration_identifier: "#{migration_identifier}-#{page.language.iso_code}",
          published: true,
          published_at: published_at,
          featured_image: {
            url: featured_image_url
          },
          blocks: [
            {
              migration_identifier: "#{root_page_identifier}-#{page.language.iso_code}-chapter",
              template_kind: 'chapter',
              data: {
                text: text
              }
            }
          ]
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

  # juin 2026
  # 6 janvier 2015
  # 2 au 5 novembre 2023
  # 1avril 2023
  # 18 et 19 septembre 2010
  # 15 & 16 septembre 2018 de 10h à 18h
  # O2
  # 12/2021
  def convert_date(date)
    return Date.current if date.blank?
    return Date.new(2012) if (date == '02')
    date = date.gsub('fevrier', 'février')
    date = date.gsub('1avril', '1 avril')
    date = date.gsub('12/2021', 'décembre 2021')
    date = date.gsub(' de 10h à 18h', '')
    fragments = date.split(' ')
    # Dernier
    year = fragments.last.to_i
    # Avant dernier
    month_name = fragments[fragments.count-2].downcase
    month = FRENCH_MONTHS.find_index(month_name)
    day = fragments.count > 2 ? fragments.first.to_i : 1
    return if month.nil?    
    Date.new(year, month+1)
  end

end
