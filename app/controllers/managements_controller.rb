class ManagementsController < ApplicationController
  layout 'management'
  before_action :authenticate_manager!

  def show
    @activities = PublicActivity::Activity.order(created_at: :desc).limit(10).includes(:owner)
  end
end
