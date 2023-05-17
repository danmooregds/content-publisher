# frozen_string_literal: true

class DocumentType::PartSummaryField
  def id
    "part_summary"
  end

  def updater_params(_edition, params)
    { contents: { part_summary: params[:part_summary] } }
  end

  def form_issues(_edition, _params)
    Requirements::CheckerIssues.new
  end

  def preview_issues(_edition)
    Requirements::CheckerIssues.new
  end

  def publish_issues(_edition)
    Requirements::CheckerIssues.new
  end
end
