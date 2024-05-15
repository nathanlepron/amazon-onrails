class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :require_login, only: %i[ create edit destroy]
  # GET /products or /products.json
  def index
    @products = Product.all
    @products = @products.where("name LIKE ?", "%#{params[:search]}%") if params[:search].present?
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  def create
    @seller = Seller.find_by(user_id: session[:user_id])
  
    if @seller.present?
      @product = @seller.products.new(product_params)
  
      if @product.save
        # Enregistrer l'image téléchargée dans le dossier des images des produits
        save_uploaded_image(@product, params[:image]) if params[:image].present?
  
        respond_to do |format|
          format.html { redirect_to product_url(@product), notice: "Product was successfully created. #{product_params[:image]}" }
          format.json { render :show, status: :created, location: @product }
        end
      else
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to root_url, alert: "Seller not found." }
        format.json { render json: { error: "Seller not found." }, status: :unprocessable_entity }
      end
    end
  end
  

  def update_stock
    if current_user
      @product = Product.find(params[:product_id])
      quantity = params[:quantity].to_i
    
      if quantity > 0 && quantity <= @product.stock
        # Créer une nouvelle transaction
        @transaction = Transaction.new(
          buyer: Buyer.find_by(user_id:session[:user_id]),
          product_id: @product.id,
          quantity: quantity,
          created_on: Time.current
        )
    
        if @transaction.save
          # Mettre à jour le stock du produit
          @product.update(stock: @product.stock - quantity)
    
          redirect_to products_path, notice: "Transaction créée avec succès."
        else
          Rails.logger.debug("Transaction errors: #{@transaction.errors.inspect}")
          redirect_to products_path, alert: "Erreur lors de la création de la transaction."
        end
      else
        redirect_to products_path, alert: "La quantité sélectionnée est invalide."
      end
    else
      redirect_to new_session_path
    end
  end
  
  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Produit mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  # DELETE /products/1 or /products/1.json
  def destroy
    @product = Product.find(params[:id])
    # Supprimer l'image associée si elle existe
    delete_image(@product.image_path) if @product.image_url.present?
    
    @product.destroy!
    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end
  
    def save_uploaded_image(product, image_param)
      return unless image_param.present?
      FileUtils.mkdir_p(Rails.root.join("app", "assets", "images", "products"))
    
      filename = "#{product.id}.#{image_param.original_filename.split('.').last}"

      File.open(Rails.root.join("app", "assets", "images", "products", filename), "wb") do |file|
        file.write(image_param.read)
      end
      product.update(image_url: "products/#{filename}")
    end

    def delete_image(image_path)
      filepath = Rails.root.join("app", "assets", "images", image_path)
      File.delete(filepath) if File.exist?(filepath)
    end
    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :description, :price, :stock, :seller_id, :image)
    end

    def require_login
      unless logged_in?
        redirect_to new_session_path, alert: "Vous devez être connecté pour créer un produit."
      end
      unless is_seller?
        redirect_to products_path, alert: "Vous n'êtes pas vendeur. Vous ne pouvez donc pas créer de produits"
      end
    end
end
