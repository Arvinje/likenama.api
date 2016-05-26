class PurchaseBundle

  attr_reader :user

  # Initializes a new Purchase.
  def initialize(user, bundle, purchase_token)
    @user = user
    @bundle = bundle
    @bazaar = BazaarService.new(bundle.bazaar_sku, purchase_token)
  end

  # Checks if the bundle has been bought before, if not,
  # purchases the bundle.
  #
  # @return [Boolean] true if the purchase is valid, false otherwise.
  def buy
    return true if BundlePurchase.exists?(bazaar_purhcase_token: @bazaar.purchase_token)
    return false unless valid?
    persist!
  end

  private

  # Calls Bazaar's API to verify the purchase. If it's not valid,
  # Adds the respective errors to the user instance.
  #
  # @return [Boolean] true if Bazaar confirms the purchase, fale otherwise.
  def valid?
    begin
      @bazaar.verify
      if @bazaar.purchased?
        true
      else
        @user.errors.add(:base, :payment_not_valid)
        false
      end
    rescue InvalidVerification => e
      Rails.logger.error e
      @user.errors.add(:base, :payment_not_valid)
      false
    rescue InvalidAuthentication => e
      Rails.logger.error e
      @user.errors.add(:base, :payment_problem)
      false
    rescue => e
      Rails.logger.error e
      @user.errors.add(:base, :payment_problem)
      false
    end
  end

  # Persists the purchase to the database and adds the purchased coin_credit plus
  # free_coins to the user's account.
  #
  # @return [Boolean] true if it got saved successfully, false otherwise.
  def persist!
    begin
      ActiveRecord::Base.transaction do
        BundlePurchase.create!(user: @user, bundle: @bundle, bazaar_purhcase_token: @bazaar.purchase_token)
        @user.coin_credit += @bundle.coins + @bundle.free_coins
        @user.save!
        true
      end
    rescue => e
      Rails.logger.error e
      @user.errors.add(:base, :payment_problem)
      false
    end
  end

end
