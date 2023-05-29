module DocumentType::ListableField
  extend ActiveSupport::Concern

  include DocumentTypeHelper

  def as_list_item(edition:, content:)
    Rails.logger.warn('in as_list_item, edition: ' + edition.inspect)
    Rails.logger.warn('in as_list_item, content: ' + content.inspect)
    Rails.logger.warn('in as_list_item, id: ' + id)
    partial_path = "documents/show/contents/#{id}_field"
    Rails.logger.warn('rendering partial path: ' + partial_path)
    locals = {
      edition:,
      content:
    }
    rendered_value = ActionController::Base.new.render_to_string(partial: partial_path, locals:)
    Rails.logger.warn('rendered, value is: ' + rendered_value)
    {
      field: t_doctype_field(edition, "#{id}.label"),
      value: rendered_value
    }
  end
end