require "json"

RSpec.describe DocumentType do
  let(:document_types) { YAML.load_file(Rails.root.join("config/document_types.yml"), aliases: true)["document_types"] }

  describe "all configured document types are valid" do
    it "conforms to the document type schema" do
      expect(document_types).to all(match_json_schema("document_type"))
    end

    it "has locale keys that conform to the document type locale schema" do
      document_types.each do |document_type|
        translations = I18n.t("document_types.#{document_type['id']}").deep_stringify_keys
        expect(translations).to match_json_schema("document_type_locale")
      end
    end

    it "has a valid document type that exists in GovukSchemas" do
      document_types.each do |document_type|
        expect(document_type["id"]).to be_in(GovukSchemas::DocumentTypes.valid_document_types)
      end
    end
  end

  describe ".contents" do
    it "gives us body for news article" do
      expect(DocumentType.find("news_story").contents.map(&:class).map(&:name)).to include("DocumentType::BodyField")
    end
  end

  describe ".content_fields" do
    it "gives us part title and part body for multipart" do
      expect(DocumentType.find("multi_part").content_fields).to include(an_instance_of(DocumentType::PartTitleField))
      expect(DocumentType.find("multi_part").content_fields).to include(an_instance_of(DocumentType::PartBodyField))
    end

    it "gives us content fields indirectly via part composite" do
      expect(DocumentType.find("multi_part").contents).to include(an_instance_of(DocumentType::PartField))
      expect(DocumentType.find("multi_part").content_fields).not_to include(an_instance_of(DocumentType::PartField))
    end
  end


  describe ".all" do
    it "creates a DocumentType for each one in the YAML" do
      expect(described_class.all.count).to eq(document_types.count)
    end
  end

  describe ".find" do
    it "returns a DocumentType when it's a known document_type" do
      expect(described_class.find("press_release")).to be_a(described_class)
    end

    it "raises a RuntimeError when we don't know the document_type" do
      expect { described_class.find("unknown_document_type") }
        .to raise_error(RuntimeError, "Document type unknown_document_type not found")
    end
  end

  describe ".clear" do
    it "resets the DocumentType.all return value" do
      preexisting_doctypes = described_class.all.count
      build(:document_type)
      expect(described_class.all.count).to eq(preexisting_doctypes + 1)
      described_class.clear
      expect(described_class.all.count).to eq(preexisting_doctypes)
    end
  end
end
