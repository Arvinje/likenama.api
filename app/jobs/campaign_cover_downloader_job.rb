class CampaignCoverDownloaderJob < ActiveJob::Base
  queue_as :default

  def perform(campaign, media_url)
    campaign.cover  = URI.parse(media_url)
    campaign.status = 'pending'
    campaign.save!
  end
end
