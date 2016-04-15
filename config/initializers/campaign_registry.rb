class CampaignRegistry
  @@campaigns = {}

  def self.load!
    Dir[Rails.application.root.to_s + "/app/models/campaigns/**/*.rb"].each { |file| require_dependency file }

    Module.constants
      .map(&:to_s)
      .select { |name| name.end_with?("Campaign") && name != "Campaign" }
      .each do |name|
        type = name.chomp("Campaign").underscore.to_sym
        campaign = Object.const_get name

        register(type, campaign)
      end
  end

  def self.register(type, campaign)
    @@campaigns[type] = campaign
  end

  def self.campaign_for(type)
    type = :"" if type.nil?
    @@campaigns.fetch(type.to_sym) { InstagramLikingCampaign }
  end

  def self.available_types
     @@campaigns.keys.map(&:to_s)
  end

end

CampaignRegistry.load!
