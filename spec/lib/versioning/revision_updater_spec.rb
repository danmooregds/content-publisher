RSpec.describe Versioning::RevisionUpdater do
  describe "#assign" do
    let(:user) { create :user }

    let(:revision) do
      create(
        :revision,
        number: 1,
        title: "old title",
        tags: { organisations: [SecureRandom.uuid] },
        change_note: "old change note",
        lead_image_revision: (create :image_revision),
        image_revisions: [create(:image_revision)],
        file_attachment_revisions: [create(:file_attachment_revision)],
      )
    end

    it "raises an error for unexpected attributes" do
      updater = described_class.new(revision, user)
      expect { updater.assign(foo: "bar") }.to raise_error ActiveModel::UnknownAttributeError
    end

    it "creates a new revision when a value changes" do
      updater = described_class.new(revision, user)
      updater.assign(title: "new title")

      next_revision = updater.next_revision
      expect(next_revision).not_to eq revision
      expect(next_revision.created_by).to eq user
      expect(next_revision.number).to eq 2
      expect(next_revision.preceded_by).to eq revision
    end

    it "updates and reports changes to the fields" do
      updater = described_class.new(revision, user)

      new_fields = {
        title: "new title",
        tags: { "organisations" => [] },
        change_note: "new change note",
        lead_image_revision: nil,
        image_revisions: [],
        file_attachment_revisions: [],
      }

      updater.assign(new_fields)
      next_revision = updater.next_revision

      expect(updater).to be_changed
      expect(updater.changes).to include(new_fields)

      new_fields.each do |name, value|
        expect(updater).to be_changed(name)
        expect(next_revision.public_send(name)).to eq value
      end
    end

    it "preserves the current revision if no change" do
      updater = described_class.new(revision, user)

      old_fields = {
        title: revision.title,
        tags: revision.tags,
        change_note: revision.change_note,
        lead_image_revision: revision.lead_image_revision,
        image_revisions: revision.image_revisions,
        file_attachment_revisions: revision.file_attachment_revisions,
      }

      updater.assign(old_fields)
      expect(updater).not_to be_changed
      expect(updater.changes).to be_empty
      expect(updater.next_revision).to eq revision
    end

    it "preserves existing values when others change" do
      updater = described_class.new(revision, user)

      old_fields = {
        title: revision.title,
        tags: revision.tags,
        change_note: revision.change_note,
        lead_image_revision: revision.lead_image_revision,
        image_revisions: revision.image_revisions,
        file_attachment_revisions: revision.file_attachment_revisions,
      }

      updater.assign(summary: "new summary")
      next_revision = updater.next_revision

      expect(next_revision).not_to eq revision

      old_fields.each do |name, value|
        expect(next_revision.public_send(name)).to eq value
      end
    end

    describe "revision with child documents" do
      let(:parent_revision) {
        revision.children << create(:document)
        revision
      }

      it "preserves associations to child documents" do
        updater = described_class.new(parent_revision, user)

        expect(parent_revision.children).not_to be_empty

        updater.assign(summary: "new summary")
        next_revision = updater.next_revision

        expect(next_revision).not_to eq parent_revision
        expect(next_revision.children).to eq revision.children
      end

      it "creates a saveable next revision" do
        updater = described_class.new(parent_revision, user)

        expect(parent_revision.children).not_to be_empty

        updater.assign(summary: "changed summary")
        next_revision = updater.next_revision

        begin
          expect(next_revision.new_record?).to eq true
          next_revision.save!
        rescue ActiveRecord::RecordInvalid => invalid
          expect(invalid.record.errors).to eq []
        end

        expect(next_revision.id).not_to be_nil
        expect(next_revision.new_record?).to eq false
      end
    end
  end
end
