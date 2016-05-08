class InstagramLikingCampaign < InstagramCampaignService

  validates :description, length: { maximum: 500 }
  validates :phone, length: { in: 10..12 }
  validates :website, length: { maximum: 150 },
                      format: { with: /\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\z/ }
  validates :address, length: { maximum: 200 }

end
