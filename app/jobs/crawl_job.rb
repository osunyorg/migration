class CrawlJob < ApplicationJob
  queue_as :default

  def perform(website)
    crawler = Crawler.new(website)
    crawler.crawl
  end
end
