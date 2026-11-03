class CrawlPageJob < ApplicationJob
  queue_as :default

  def perform(page)
    crawler = Crawler.new(page.website, start_page: page)
    crawler.crawl
  end
end
