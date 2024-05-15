class HomeController < ApplicationController
    def index
        @all_buyers = get_buyers
        @all_sellers = get_sellers
        @last_4_products = get_latest_products
    end
end
