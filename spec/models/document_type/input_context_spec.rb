# frozen_string_literal: true
RSpec.describe DocumentType::InputContext do
  describe "top level behaviour" do
    let(:top_level_context) {
      DocumentType::InputContext.new([])
    }

    it "returns a plain id for string id" do
      expect(top_level_context.id('bob')).to eq 'bob'
    end

    it "returns a plain id for symbol id" do
      expect(top_level_context.id(:bob)).to eq 'bob'
    end

    it "returns a plain name for symbol name" do
      expect(top_level_context.name(:bob)).to eq 'bob'
    end

    it "returns a plain name for string name" do
      expect(top_level_context.name('bob')).to eq 'bob'
    end
  end

  describe "object sub-field behaviour" do
    let(:object_context) {
      DocumentType::InputContext.new([:top_obj])
    }

    it "returns an id prefixed with object context" do
      expect(object_context.id(:bob)).to eq 'top_obj__bob'
    end

    it "returns a name keyed within object name" do
      expect(object_context.name(:bob)).to eq 'top_obj[bob]'
    end
  end

  describe "#new" do
    it "gives top level context by default if no ancesters passed" do
      expect(DocumentType::InputContext.new.id(:bob)).to eq 'bob'
    end
  end

  describe "#sub_context" do
    let(:original_context) {
      DocumentType::InputContext.new([:parent])
    }

    it "creates a sub-context within the original context" do
      expect(original_context.sub_context(:foo).id(:bar)).to eq 'parent__foo__bar'
    end
  end

  describe "nested object sub-field behaviour" do
    let(:nested_context) {
      DocumentType::InputContext.new([:top_obj, :lower])
    }

    it "returns an id prefixed with nested context" do
      expect(nested_context.id(:bob)).to eq 'top_obj__lower__bob'
    end

    it "returns a name keyed within nested named object" do
      expect(nested_context.name(:bob)).to eq 'top_obj[lower][bob]'
    end
  end

  describe "deep nested object sub-field behaviour" do
    let(:nested_context) {
      DocumentType::InputContext.new([:top_obj, :middle, :lower, :parent])
    }

    it "returns a name keyed within deeply nested named object" do
      expect(nested_context.name(:bob)).to eq 'top_obj[middle][lower][parent][bob]'
    end
  end

  describe "intermediate array index behaviour" do
    let(:arrayed_context) {
      DocumentType::InputContext.new([:top_obj, 1, :parent])
    }

    it "returns a name keyed within nested named object hierarchy with an array index in there" do
      expect(arrayed_context.name(:bob)).to eq 'top_obj[1][parent][bob]'
    end
  end

end

