# frozen_string_literal: true

class DocumentType::PartBodyField
  def id
    "part_body"
  end

  def updater_params(_edition, params)
    { contents: { part_body: params[:part_body] } }
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
