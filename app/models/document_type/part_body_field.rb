# frozen_string_literal: true

class DocumentType::PartBodyField
  def list_content_fields
    [self]
  end

  def id
    "part_body"
  end

  def field_value(content_context)
    content_context[id] unless content_context.nil?
  end

  def to_payload(edition, contents)
    GovspeakDocument.new(field_value(contents), edition).payload_html
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
