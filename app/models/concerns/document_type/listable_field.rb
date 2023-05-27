module DocumentType::ListableField
  extend ActiveSupport::Concern

  include DocumentTypeHelper

  def as_list_item(edition:, content:, label_override: nil)
    Rails.logger.warn('in as_list_item, edition: ' + edition.inspect)
    Rails.logger.warn('in as_list_item, content: ' + content.inspect)
    Rails.logger.warn('in as_list_item, id: ' + id)
    partial_path = "documents/show/contents/#{id}_field"
    locals = {
      edition:,
      content:
    }
    rendered_value = ActionController::Base.new.render_to_string(partial: partial_path, locals:)
    if not label_override
      label = t_doctype_field(edition, "#{id}.label")
    else
      label = label_override
    end
    {
      field: label.to_s,
      value: rendered_value
    }
  end
end
