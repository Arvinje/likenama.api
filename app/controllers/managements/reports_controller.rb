class Managements::ReportsController < ApplicationController
  layout 'management'
  before_action :authenticate_manager!
  before_action :find_report, only: [:check, :uncheck, :destroy]

  def index
    @reports = Report.order(created_at: :desc).includes(:user, :campaign).page(params[:page])
  end

  def show
  end

  def check
    @report.check!
    @report.create_activity :checked, owner: current_manager
    redirect_to management_reports_path
  end

  def uncheck
    @report.uncheck!
    @report.create_activity :unchecked, owner: current_manager
    redirect_to management_reports_path
  end

  # def destroy
  #   @report.destroy
  #   redirect_to management_reports_path
  # end

  private

  def find_report
    @report = Report.find params[:id]
  end
end
