# frozen_string_literal: true

class DocumentType::PartField
  def id
    "part"
  end

  def externalise_content_fields(fields)
    fields.concat contents
  end

  def field_value(content_context)
    content_context[id] unless content_context.nil?
  end

  def contents
    [DocumentType::PartTitleField.new, DocumentType::PartSummaryField.new, DocumentType::PartBodyField.new]
  end

  def payload(edition, payload_context, contents)
    part_payload = {}
    part_content = contents[id]
    DocumentType::PartTitleField.new.payload(edition, part_payload, part_content)
    DocumentType::PartSummaryField.new.payload(edition, part_payload, part_content)
    DocumentType::PartBodyField.new.payload(edition, part_payload, part_content)
    payload_context.deep_merge!(parts: [part_payload])
  end

  def updater_params(_edition, params)
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
