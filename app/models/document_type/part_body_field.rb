# frozen_string_literal: true

class DocumentType::PartBodyField

  def add_content_fields(fields)
    fields.push(self)
  end

  def id
    "part_body"
  end

  def payload(edition, payload_context, contents)
    payload_context.deep_merge! body: GovspeakDocument.new(contents[id], edition).payload_html
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
