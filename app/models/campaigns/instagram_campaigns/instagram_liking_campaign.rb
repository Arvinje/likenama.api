class InstagramLikingCampaign < InstagramCampaignService

  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :phone, length: { in: 10..12 }, allow_blank: true
  validates :website, length: { maximum: 150 }, allow_blank: true,
                      format: { with: /\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\z/ }
  validates :address, length: { maximum: 200 }, allow_blank: true

end
