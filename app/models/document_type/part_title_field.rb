# frozen_string_literal: true

class DocumentType::PartTitleField
  def add_content_fields(fields)
    fields.push(self)
  end

  def id
    "part_title"
  end

  def updater_params(_edition, params)
    { contents: { part_title: params[:part_title] } }
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
