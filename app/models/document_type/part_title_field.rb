# frozen_string_literal: true

class DocumentType::PartTitleField
  include DocumentType::ListableField

  def top_level_field?
    false
  end

  def as_list_items(edition:, content:, label_override:)
    [ as_list_item(edition:, content:, label_override:) ]
  end

  def list_content_fields
    [self]
  end

  def id
    "part_title"
  end

  def to_payload(edition, content)
    content
  end

  def updater_params(_edition, params)
    raise 'WIP not yet moved to composite-pattern hierarchical content updates'

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
