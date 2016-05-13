class CreateOrganizedCampaignClasses

  def initializer
    @campaign_types = Set.new
    @organized_classes = {}
  end

  def self.me
    $hash = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    campaign_types = CampaignClass.active.pluck(:campaign_type)
    campaign_types.each do |campaign_type|
      payment_types = CampaignClass.active.where(campaign_type: campaign_type).pluck(:payment_type)
      payment_types.each do |payment_type|
        waiting_types = CampaignClass.active.where(campaign_type: campaign_type, payment_type: payment_type).pluck(:waiting)
        waiting_types.each do |waiting|
          record = CampaignClass.active.where(campaign_type: campaign_type, payment_type: payment_type, waiting: waiting)
          $hash[campaign_type][payment_type][waiting] = record
        end
      end
    end
  end
  $hash

end


{
  campaign_types: ['insta', 'teleg'],
  insta: {
    payment_types: ['coin', 'like'],
    coin: {
      waiting_types: ['with', 'without'],
      with_waiting: "OBJECT",
      without_waiting: "THAT"
    },
    like: {
      waiting_types: ['without'],
      without_waiting: "THOSE"
    }
  },
  teleg: {
    payment_types: ['coin', 'like'],
    coin: {
      waiting_types: ['with', 'without'],
      with_waiting: "OBJECT",
      without_waiting: "THAT"
    },
    like: {
      waiting_types: ['without'],
      without_waiting: "THOSE"
    }
  }
}
