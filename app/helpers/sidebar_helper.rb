module SidebarHelper

  def mark_new(resource)
    return if current_manager.nil?
    send("mark_new_#{resource.to_s}")
  end

  # Marks the sidebar tab red when there's
  # at least one unresolved report.
  def mark_new_reports
    "color: orange;" if Report.uncheck.count > 0
  end

  # Marks the sidebar tab red when there's
  # at least one unresolved report.
  def mark_new_campaigns
    "color: orange;" if Campaign.pending.present?
  end

end
