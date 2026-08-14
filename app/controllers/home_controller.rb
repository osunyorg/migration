class HomeController < ApplicationController
  def index
    @websites = Website.ordered
  end
end
