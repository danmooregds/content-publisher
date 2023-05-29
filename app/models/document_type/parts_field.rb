# frozen_string_literal: true

class DocumentType::PartsField
  def id
    "parts"
  end

  def contents
    [DocumentType::PartField.new]
  end

  def list_content_fields
    contents.map(&:list_content_fields)
  end

  def field_value(content_context)
    content_context
  end

  def to_payload(edition, contents)
    Rails.logger.warn('parts content ' + contents.inspect)
    part_payload = DocumentType::PartField.new.to_payload(edition, contents)
    [part_payload]
  end

  def updater_params(_edition, params)
    Rails.logger.warn('parts params: ' + params.inspect)
    Rails.logger.warn('parts params[:parts]: ' + params[:parts].inspect)
    Rails.logger.warn("parts params['parts']: " + params['parts'].inspect)
    Rails.logger.warn("parts params['parts'][0]: " + params['parts'][0].inspect)
    Rails.logger.warn("parts params['parts']['0']: " + params['parts']['0'].inspect)
    {
      contents: {
        part: {
          part_title: params['parts']['0']['part_title'],
          part_body: params['parts']['0']['part_body'],
          part_summary: params['parts']['0']['part_summary'],
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
