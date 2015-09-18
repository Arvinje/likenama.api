class DashboardsController < ApplicationController
  before_action :authenticate_user!
  layout 'dashboard'
  
  def new
  end
end
