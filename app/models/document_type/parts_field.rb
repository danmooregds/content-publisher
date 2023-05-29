# frozen_string_literal: true

class DocumentType::PartsField
  def as_list_items(edition:, content:)
    Rails.logger.warn('parts field as list items, content: ' + content.inspect)
    [ DocumentType::PartField.new.as_list_items(edition:, content: content['parts'][0]) ]
  end

  def id
    "parts"
  end

  def contents
    [DocumentType::PartField.new]
  end

  def list_content_fields
    contents.map(&:list_content_fields)
  end

  def subfield_content(content, subfield)
    Rails.logger.warn('subfield_content parts content: ' + content.inspect)
    content[0]
  end

  def to_payload(edition, contents)
    [DocumentType::PartField.new.to_payload(edition, contents[0])]
  end

  def updater_params(_edition, params)
    Rails.logger.warn('parts params: ' + params.inspect)
    Rails.logger.warn('parts params[:parts]: ' + params[:parts].inspect)
    Rails.logger.warn("parts params['parts']: " + params['parts'].inspect)
    Rails.logger.warn("parts params['parts'][0]: " + params['parts'][0].inspect)
    Rails.logger.warn("parts params['parts']['0']: " + params['parts']['0'].inspect)
    {
      contents: {
        parts: [{
          part_title: params['parts']['0']['part_title'],
          part_body: params['parts']['0']['part_body'],
          part_summary: params['parts']['0']['part_summary'],
        }],
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
