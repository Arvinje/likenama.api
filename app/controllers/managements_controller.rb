class ManagementsController < ApplicationController
  layout 'management'
  before_action :authenticate_manager!

  def show
  end
end
