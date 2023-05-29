# frozen_string_literal: true

class DocumentType::InputContext
  def initialize(ancestors = [])
    @ancestors = ancestors
  end

  def sub_context(id)
    DocumentType::InputContext.new(@ancestors + [ id ])
  end

  def id(my_id)
    last_id = my_id.to_s
    (@ancestors + [ last_id ]).join '__'
  end

  def name(my_name)
    last_name = my_name.to_s
    if @ancestors.empty?
      last_name
    else
      ancestors_prefix + "[#{last_name}]"
    end
  end

  private

  def ancestors_prefix
    return @ancestors[0].to_s if @ancestors.length == 1
    @ancestors[0].to_s + @ancestors.slice(1, @ancestors.length).map {|id| "[#{id.to_s}]"}.join('')
  end
end
