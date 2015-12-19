class Managements::CampaignsController < ApplicationController
  layout 'management'
  before_action :authenticate_manager!
  before_action :find_campaign, only: [:show, :update]

  def index
    @campaigns = Campaign.order(created_at: :desc).take(10)
  end

  def show
    @user_campaigns = @campaign.owner.campaigns.limit(5).order(created_at: :desc)
  end

  def update
    case params[:commit]
    when " پذیرش"
      @campaign.verify!
    when " درحال بررسی"
    when " غیرقابل قبول"
      @campaign.reject!
    end
    redirect_to [:management, @campaign]
  end

  private

  def find_campaign
    @campaign = Campaign.find params[:id]
  end
end
