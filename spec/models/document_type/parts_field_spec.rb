RSpec.describe DocumentType::PartsField do
  describe "#updater_params" do
    it "returns a hash of the part" do
      edition = build :edition
      params = ActionController::Parameters.new(parts: {'0' => {part_title: "the part title",
                                                part_body: "the part body",
                                                part_summary: "the part summary"}})
      updater_params = described_class.new.updater_params(edition, params)
      expect(updater_params).to eq(contents: {
        parts: [{
          part_title: "the part title",
          part_body: "the part body",
          part_summary: "the part summary"
        }]
      })
    end
  end

end
