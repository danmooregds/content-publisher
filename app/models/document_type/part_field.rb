# frozen_string_literal: true

class DocumentType::PartField
  def id
    "part"
  end

  def add_content_fields(fields)
    fields.push(DocumentType::PartTitleField.new)
    fields.push(DocumentType::PartSummaryField.new)
    fields.push(DocumentType::PartBodyField.new)
  end

  def payload(edition, payload_context, contents)
    part_payload = {}
    part_content = contents[id]
    DocumentType::PartTitleField.new.payload(edition, part_payload, part_content)
    DocumentType::PartSummaryField.new.payload(edition, part_payload, part_content)
    DocumentType::PartBodyField.new.payload(edition, part_payload, part_content)
    payload_context.deep_merge!(part: part_payload)
  end

  def updater_params(_edition, params)
    { contents: { part: params[:part] } }
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
