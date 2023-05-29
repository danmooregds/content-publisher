# frozen_string_literal: true

class DocumentType::PartBodyField
  include DocumentType::ListableField

  def as_list_items(edition:, content:)
    [ as_list_item(edition:, content:) ]
  end

  def list_content_fields
    [self]
  end

  def id
    "part_body"
  end

  def to_payload(edition, content)
    GovspeakDocument.new(content, edition).payload_html
  end

  def updater_params(_edition, params)
    raise 'WIP not yet moved to composite-pattern hierarchical content updates'

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
