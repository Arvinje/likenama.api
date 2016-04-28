class Managements::CampaignsController < ApplicationController
  layout 'management'
  before_action :authenticate_manager!
  before_action :find_campaign, only: [:show, :update]

  def index
    @campaigns = Campaign.where.not(status: nil).order(created_at: :desc).page(params[:page])
  end

  def show
    @user_campaigns = @campaign.owner.campaigns.limit(5).order(created_at: :desc)
  end

  def update
    case params[:commit]
    when " پذیرش"
      @campaign.verify!
      @campaign.create_activity :verified, owner: current_manager
    when " درحال بررسی"
    when " غیرقابل قبول"
      @campaign.reject!
      @campaign.create_activity :rejected, owner: current_manager
    end
    redirect_to management_campaign_path(@campaign)
  end

  private

  def find_campaign
    @campaign = Campaign.find params[:id]
  end
end
