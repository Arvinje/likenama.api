module SidebarHelper

  def mark_new(resource)
    return if current_manager.nil? # Prevents it from showing in unrestricted area
    send("mark_new_#{resource.to_s}")
  end

  # Marks the sidebar tab orange when there's
  # at least one unresolved report.
  def mark_new_reports
    "color: orange;" if Report.uncheck.count > 0
  end

  # Marks the sidebar tab orange when there's
  # at least one campaign needing attention.
  def mark_new_campaigns
    "color: orange;" if Campaign.pending.present?
  end

  # Marks the sidebar tab orange when there's
  # at least one message unseen.
  def mark_new_messages
    "color: orange;" if Message.unread.count > 0
  end

end
