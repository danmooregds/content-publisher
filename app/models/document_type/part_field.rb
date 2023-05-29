# frozen_string_literal: true

class DocumentType::PartField
  def id
    "part"
  end

  def contents
    [DocumentType::PartTitleField.new, DocumentType::PartSummaryField.new, DocumentType::PartBodyField.new]
  end

  def list_content_fields
    contents.map(&:list_content_fields)
  end

  def field_value(content_context)
    content_context[id] unless content_context.nil?
  end

  def to_payload(edition, content_context)
    Rails.logger.warn('part content context ' + content_context.inspect)
    part_content = content_context[id]
    title = DocumentType::PartTitleField.new.to_payload(edition, part_content)
    description = DocumentType::PartSummaryField.new.to_payload(edition, part_content)
    body = DocumentType::PartBodyField.new.to_payload(edition, part_content)
    {
      title:,
      slug: title.parameterize,
      description: description,
      body: body
    }
  end

  def updater_params(_edition, params)
    raise 'WIP not yet moved to composite-pattern hierarchical content updates'
    {
      contents: {
        part: {
          part_title: params[:part_title],
          part_body: params[:part_body],
          part_summary: params[:part_summary],
        },
      },
    }
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
end
