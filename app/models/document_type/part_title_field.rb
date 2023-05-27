# frozen_string_literal: true

class DocumentType::PartTitleField
  def list_content_fields
    [self]
  end

  def id
    "part_title"
  end

  def field_value(content_context)
    content_context[id] unless content_context.nil?
  end

  def to_payload(edition, content_context)
    Rails.logger.warn('part title content ' + content_context.inspect)

    field_value(content_context)
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
