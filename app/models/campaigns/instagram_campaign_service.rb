class InstagramCampaignService < Campaign

  def creation_validator
    InstagramPhotoValidator.new(self)
  end

  def liking_validator
    InstagramLikeValidator
  end

  def target_url
    if @target_url
      @target_url
    else
      "http://instagram.com/p/#{target}"
    end
  end

end
