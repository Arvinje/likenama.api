class ManagementsController < ApplicationController
  layout 'management'
  before_action :authenticate_manager!

  def show
    @activities = PublicActivity::Activity.all
  end
end
