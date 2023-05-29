# frozen_string_literal: true

class DocumentType::PartField
  def id
    "part"
  end

  def as_list_items(edition:, content:)
    contents.map do |subfield|
      subfield.as_list_items(edition:, content: content[subfield.id])
    end
  end

  def contents
    [DocumentType::PartTitleField.new, DocumentType::PartSummaryField.new, DocumentType::PartBodyField.new]
  end

  def list_content_fields
    contents.map(&:list_content_fields)
  end

  def subfield_content(content, subfield)
    # key = subfield.id.sub /^part_/, ''
    content[subfield.id]
  end

  def to_payload(edition, content)
    Rails.logger.warn('part content: ' + content.inspect)
    title = DocumentType::PartTitleField.new.to_payload(edition, content['part_title'])
    description = DocumentType::PartSummaryField.new.to_payload(edition, content['part_summary'])
    body = DocumentType::PartBodyField.new.to_payload(edition, content['part_body'])
    {
      title:,
      slug: title.parameterize,
      description: description,
      body: body
    }
  end

  def updater_params(_edition, params)
    raise 'WIP not yet moved to composite-pattern hierarchical content updates'
  end

  def input_context
    InputContext.new
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

  private

end
