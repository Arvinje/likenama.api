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

  # Gets photo address from Instagram API and
  # calls {CampaignCoverDownloaderJob} job to fetch the cover
  def fetch_cover
    media = Instagram.client.media_shortcode(target)
    CampaignCoverDownloaderJob.perform_later self, media.images.standard_resolution.url
  end

  # Returns Instagram photo url based on the target
  #
  # @return [String] Instagram photo url.
  def target_url
    @target_url || "http://instagram.com/p/#{target}"
  end

end
