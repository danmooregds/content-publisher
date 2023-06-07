FactoryBot.define do
  trait :revision_fields do
    transient do
      title { SecureRandom.alphanumeric(10) }
      base_path { title ? "/prefix/#{title.parameterize}" : nil }
      document_type_id { document_type.id }
      document_type { build(:document_type, path_prefix: "/prefix") }
      summary { nil }
      contents { {} }
      tags do
        if created_by&.organisation_content_id
          { primary_publishing_organisation: [created_by.organisation_content_id] }
        else
          {}
        end
      end
      update_type { "major" }
      change_note { nil }
      proposed_publish_time { nil }
      backdated_to { nil }
      editor_political { nil }
      change_history { [] }
      featured_attachment_ordering { [] }
    end
  end

  factory :revision do
    association :created_by, factory: :user
    document
    association :lead_image_revision, factory: :image_revision
    image_revisions { lead_image_revision ? [lead_image_revision] : [] }

    revision_fields

    after(:build) do |revision, evaluator|
      revision.number = revision.document&.next_revision_number unless revision.number

      unless revision.content_revision
        revision.content_revision = evaluator.association(
          :content_revision,
          title: evaluator.title,
          base_path: evaluator.base_path,
          summary: evaluator.summary,
          contents: evaluator.contents,
          created_by: revision.created_by,
        )
      end

      unless revision.metadata_revision
        revision.metadata_revision = evaluator.association(
          :metadata_revision,
          update_type: evaluator.update_type,
          change_note: evaluator.change_note,
          created_by: revision.created_by,
          proposed_publish_time: evaluator.proposed_publish_time,
          backdated_to: evaluator.backdated_to,
          document_type_id: evaluator.document_type_id,
          editor_political: evaluator.editor_political,
          change_history: evaluator.change_history,
          featured_attachment_ordering: evaluator.featured_attachment_ordering,
        )
      end

      unless revision.tags_revision
        revision.tags_revision = evaluator.association(
          :tags_revision,
          tags: evaluator.tags,
          created_by: revision.created_by,
        )
      end

    end
  end
end
