class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    def not_found_method
      render template: 'shared/404', status: :not_found, layout: 'layouts/application'
    end
    private
    
  
    def current_user
      Rails.logger.debug("User ID in session: #{session[:user_id].inspect}") # ajoutez cette ligne pour le débogage
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
    
    def is_buyer?
        !!Buyer.find_by(user_id: session[:user_id]) if session[:user_id]
    end

    def is_seller?
        !!Seller.find_by(user_id: session[:user_id]) if session[:user_id]
    end
  
    def logged_in?
      !!current_user
    end
    def get_buyers
      Buyer.all
    end
    
    def get_sellers
      Seller.all
    end
    def get_latest_products
      Product.order(created_at: :desc).limit(4)
    end
    helper_method :current_user, :logged_in?, :is_buyer?, :is_seller?, :get_buyers, :get_sellers
  end