class Parenting < ApplicationRecord
  belongs_to :parent, class_name: "Revision", foreign_key: "parent_id"
  belongs_to :child, class_name: "Document", foreign_key: "child_id"

  default_scope { order('ordinal ASC') }

end
