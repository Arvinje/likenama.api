class Api::V1::InstagramDetailSerializer < ActiveModel::Serializer
  attributes :url, :photo_url, :description, :phone, :website, :address

  def url
    "https://instagram.com/p/#{object.short_code}"
  end
end
