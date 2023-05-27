# frozen_string_literal: true

class DocumentType::PartsField
  def top_level_field?
    false
  end

  def as_list_items(edition:, content:)
    Rails.logger.warn('parts field as list items, content: ' + content.inspect)
    part_count = content.length
    (0..(part_count - 1)).map do |index|
      DocumentType::PartField.new.as_list_items(edition:, content: content[index], index: index + 1)
    end
  end

  def id
    "parts"
  end

  def fields
    [DocumentType::PartField.new]
  end

  def subfield_content(content, subfield)
    Rails.logger.warn('subfield_content parts content: ' + content.inspect)
    return [{}] if content.nil? or content.empty? # default form
    content
  end

  def to_payload(edition, contents)
    contents.map {|part_content| DocumentType::PartField.new.to_payload(edition, part_content) }
  end

  def updater_params(_edition, params)
    max_part_index = params['parts'].keys.length - 1

    parts = (0..max_part_index).map do |index|
      {
        part_title: params['parts'][index.to_s]['part_title'],
        part_body: params['parts'][index.to_s]['part_body'],
        part_summary: params['parts'][index.to_s]['part_summary'],
      }
    end
    {
      contents: {
        parts: parts,
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
