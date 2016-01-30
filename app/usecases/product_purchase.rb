class ProductPurchase
  attr_reader :user, :purchased_detail

  # Initializes a new instance of ProductPurchase
  #
  # @param user [User] the customer
  # @param product [Product] the selected product
  def initialize(user, product)
    @user = user
    @product = product
  end

  # Purchases the product.
  # If there's a problem with the purchase, adds respective errors
  # to the user object
  #
  # @return [Boolean] true if the operation was successful, false otherwise.
  def buy
    if @product.price <= @user.coin_credit # Checks whether the user has enough coin_credit or not
      purchase
    else
      @user.errors.add(:coin_credit, :not_enough_credit)
      false
    end
  end

  private

  # Performs the purchase operation.
  # decreases the user's coin_credit by the product's price and
  # selects an available detail and adds it to the user's purchased_details.
  # Adds respective errors if the operation fails for any reasons.
  #
  # @return [Boolean] true if the operation was successful, false otherwise.
  def purchase
    begin
      ActiveRecord::Base.transaction do
        @user.coin_credit -= @product.price
        requested_detail = @product.details.available.first
        requested_detail.available = false    # makes the detail unavailable
        requested_detail.save!
        @user.save!
        @user.purchased_details << requested_detail   # adds the detail to purchased_details of the user
        @purchased_detail = requested_detail
      end
      true
    rescue
      @user.reload
      @user.errors.add(:base, :purchase_problem)
      false
    end
  end

end
