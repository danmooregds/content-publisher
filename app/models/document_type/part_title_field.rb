# frozen_string_literal: true

class DocumentType::PartTitleField
  def externalise_content_fields(fields)
    fields.push(self)
  end

  def id
    "part_title"
  end

  def field_value(content_context)
    content_context[id] unless content_context.nil?
  end

  def payload(edition, payload_context, content_context)
    payload_context.deep_merge! title: field_value(content_context)
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
