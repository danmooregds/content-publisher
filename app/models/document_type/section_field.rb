# frozen_string_literal: true

class DocumentType::SectionField
  def id
    "section"
  end

  def updater_params(_edition, params)
    { contents: { section: params[:section] } }
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
