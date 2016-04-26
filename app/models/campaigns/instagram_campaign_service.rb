class InstagramCampaignService < Campaign

  has_attached_file :cover,
                    path: ":rails_root/public/system/:class/:attachment/:id_partition/:style/:filename",
                    styles: {
                              medium: "300x300>",
                               thumb: "100x100>"
                            }

  validates_attachment :cover,
                        content_type: { content_type: "image/jpeg" },
                        size: { in: 0..2.megabytes }

  def creation_validator
    InstagramPhotoValidator.new(self)
  end

  def liking_validator
    InstagramLikeValidator
  end

  # Sets a {CampaignClass} based on the request for waiting, campaign_type
  # and payment_type.
  def set_campaign_class!
    self.campaign_class = if waiting == true
                            CampaignClass.active.where(campaign_type: type,
                                                payment_type: payment_type)
                                         .where.not(waiting: 0).last
                          else
                            CampaignClass.active.where(campaign_type: type,
                                                payment_type: payment_type,
                                                waiting: 0).last
                          end
  end

  # Gets photo address from Instagram API and
  # calls {CampaignCoverDownloaderJob} job to fetch the cover
  def fetch_cover
    media = Instagram.client.media_shortcode(target)
    CampaignCoverDownloaderJob.set(wait: 10.second)
                              .perform_later self, media.images.standard_resolution.url
  end

  # Returns Instagram photo url based on the target
  #
  # @return [String] Instagram photo url.
  def target_url
    @target_url || "http://instagram.com/p/#{target}"
  end

end
