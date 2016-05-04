class BazaarError < StandardError; end
class InvalidVerification < BazaarError; end
class InvalidAuthentication < BazaarError; end

class BazaarService

  attr_reader :purchase_token, :payload, :purchase_time

  # Initializes a new Bazaar verification check
  #
  # @return [BazaarService]
  def initialize(sku, purchase_token)
    @sku = sku
    @purchase_token = purchase_token
    @auth_tries = 0
    fetch_settings
  end

  # Makes sure that there's a valid access token available.
  # Verifies the requested purchase.
  #
  # @return [BazaarService] returns self
  def verify
    setup
    verify_purchase
    self
  end

  # Checks if the purchase has been made.
  #
  # @return [Boolean] true if the purchase is valid, false if it's refunded
  def purchased?
    @purchased
  end

  # Checks if the product is consumed.
  #
  # @return [Boolean] true if so, false otherwise
  def consumed?
    @consumed
  end

  private

  # Returns Redis instance.
  #
  # @return [Redis::Namespace] redis instance
  def redis
    $redis
  end

  # Fetches and assigns client's settings.
  def fetch_settings
    @authorization_code = Rails.application.secrets.bazaar_authorization_code
    @client_id = Rails.application.secrets.bazaar_client_id
    @client_secret = Rails.application.secrets.bazaar_client_secret
    @redirect_uri = Rails.application.secrets.bazaar_redirect_uri
    @package_name = Rails.application.secrets.bazaar_package_name
    @access_token = redis['bazaar_access_token']
    @refresh_token = redis['bazaar_refresh_token']
  end

  # Requests new token based on the provided details.
  # If the token is valid and available, does nothing.
  def setup
    if @access_token.blank? && @refresh_token.present?
      refresh_access_token
    elsif @access_token.present? && @refresh_token.present?
      return
    else
      get_fresh_access_token
    end
  end

  # Requests an access_token for the first time.
  #
  # @return [Boolean] true if the response is valid.
  def get_fresh_access_token
    response = HTTP.post('https://pardakht.cafebazaar.ir/devapi/v2/auth/token/',
          form: {
                  grant_type: 'authorization_code',
                  code: @authorization_code,
                  client_id: @client_id,
                  client_secret: @client_secret,
                  redirect_uri: @redirect_uri
                })
    validate_authentication_response response
  end

  # Checks the response HTTP Status.
  # Raise InvalidAuthentication if the response is invalid.
  #
  # @return [TrueClass]
  def validate_authentication_response(response)
    raise InvalidAuthentication if response.code >= 400
    persist_authentication_response response.parse
    true
  end

  # Saves the access_token and refresh_token to Redis.
  # Sets a expire date on the access_token instance.
  def persist_authentication_response(response)
    @access_token = response['access_token']
    redis['bazaar_access_token'] = response['access_token']
    redis.expire('bazaar_access_token', response['expires_in'].to_i)
    if response.has_key? 'refresh_token'
      @refresh_token = response['refresh_token']
      redis['bazaar_refresh_token'] = response['refresh_token']
    end
  end

  # Requests a new access_token.
  #
  # @return [Boolean] true if the response is valid.
  def refresh_access_token
    response = HTTP.post('https://pardakht.cafebazaar.ir/devapi/v2/auth/token/',
          form: {
                  grant_type: 'refresh_token',
                  client_id: @client_id,
                  client_secret: @client_secret,
                  refresh_token: @refresh_token
                })
    validate_authentication_response response
  end

  # Checks the purchase details with Bazaar and validates the response.
  def verify_purchase
    response =
                HTTP.auth(@access_token)
                    .get("https://pardakht.cafebazaar.ir/devapi/v2/api/validate/#{@package_name}/inapp/#{@sku}/purchases/#{@purchase_token}/", )
    validate_verification_response response
  end

  # Validates Bazaar's response and assigns {@purchase}, {@consumed}, {@payload}
  # and {@purchase_time}.
  # Raises InvalidVerification if the response is not valid.
  # Retries upto 5 times to get a new access_token if the response was a 401.
  def validate_verification_response(response)
    if response.code == 401 && @auth_tries < 5
      @auth_tries += 1
      verify
      return
    end
    raise InvalidVerification if response.code >= 400
    result = response.parse
    @purchased = result['purchaseState'] == 0 ? true : false
    @consumed  = result['consumptionState'] == 0 ? true : false
    @payload = result['developerPayload']
    @purchase_time = Time.at(result['purchaseTime']/1000)
  end

end
