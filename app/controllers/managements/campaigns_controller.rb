class Managements::CampaignsController < ApplicationController
  layout 'management'
  before_action :authenticate_manager!
  
  def index
    @campaigns = Campaign.order(created_at: :desc).take(10)
  end

  def show
    @campaign = Campaign.find params[:id]
    @user_campaigns = @campaign.owner.campaigns.limit(5).order(created_at: :desc)
  end
end
