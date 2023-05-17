# frozen_string_literal: true

class DocumentType::PartField
  def id
    "part"
  end

  def add_content_fields(fields)
    fields.push(DocumentType::PartTitleField.new)
    fields.push(DocumentType::PartSummaryField.new)
    fields.push(DocumentType::PartBodyField.new)
  end

  def updater_params(_edition, params)
    { contents: { part: params[:part] } }
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
