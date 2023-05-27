require_relative '../concerns/document_type/listable_field.rb'

class DocumentType::BodyField
  include DocumentType::ListableField

  def top_level_field?
    false
  end

  def as_list_items(edition:, content:)
    [ as_list_item(edition:, content:) ]
  end

  def list_content_fields
    [self]
  end

  def id
    "body"
  end

  def to_payload(edition, content)
    GovspeakDocument.new(content, edition).payload_html
  end

  def updater_params(_edition, params)
    { contents: { body: params[:body] } }
  end

  def form_issues(edition, params)
    issues = Requirements::CheckerIssues.new

    unless GovspeakDocument.new(params[:contents][:body], edition).valid?
      issues.create(id, :invalid_govspeak)
    end

    issues
  end

  def preview_issues(_edition)
    Requirements::CheckerIssues.new
  end

  def publish_issues(edition)
    issues = Requirements::CheckerIssues.new
    issues.create(id, :blank) if edition.contents[id].blank?
    issues
  end
end
