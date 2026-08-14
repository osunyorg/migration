class Crawler
  attr_reader :website, :started_at

  def initialize(website)
    @website = website
  end

  def crawl
    return unless default_language
    @started_at = Time.current
    crawl_page(root_path)
    crawl_translations
  end

  protected

  def crawl_page(url_or_path)
    if url_or_path.start_with?('http')
      uri = URI.parse(url_or_path)
    else
      uri = URI.join(website.url, url_or_path)
    end

    page = website.pages.where(url: uri.to_s).first_or_initialize
    return if page.persisted? && page.crawled_at >= started_at

    puts "Crawling #{uri.to_s} in 1 second."
    sleep 1

    html = uri.open.read
    language_iso_code = uri.path.split('/')[1]
    language = default_language.iso_code == language_iso_code ? default_language : website.languages.find_by(iso_code: language_iso_code)
    return if language.nil?

    parsed_html = Nokogiri::HTML5(html)
    title = parsed_html.title.strip

    page.assign_attributes(
      title: title,
      html: html,
      language_id: language.id,
      crawled_at: Time.current
    )
    page.save

    links = parsed_body.css('a').map { |node| node["href"] }
    whitelisted_links = links.select { |link|
      link.start_with?(root_path) || link.start_with?(root_url)
    }

    whitelisted_links.map!(&:strip).uniq!
    whitelisted_links.each do |link|
      crawl_page(link)
    end
  end

  def crawl_translations
    languages = website.languages.where.not(id: default_language.id)
    website.pages.where(language: default_language).each do |page|
      languages.each do |language|
        crawl_page_translation(page, language)
      end
    end
  end

  def crawl_page_translation(page, language)
    page_url = page.url
    page_translation_url = page_url.gsub(
      root_url,
      root_url(language: language)
    )

    uri = URI.parse(page_translation_url)
    puts "Crawling #{uri.to_s} in 1 second."
    sleep 1

    html = uri.open.read
    parsed_html = Nokogiri::HTML5(html)
    title = parsed_html.title.strip

    translation_page = website.pages.where(url: uri.to_s).first_or_initialize
    translation_page.assign_attributes(
      title: title.presence || "-",
      html: html,
      language_id: language.id,
      parent: page,
      crawled_at: Time.current
    )
    translation_page.save
  end

  def default_language
    @default_language ||= @website.default_language
  end

  def root_path(language: default_language)
    "/#{language.iso_code}/"
  end

  def root_url(language: default_language)
    URI.join(website.url, root_path(language: language)).to_s
  end
end
