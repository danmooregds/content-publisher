# frozen_string_literal: true

class ChildrenController < ApplicationController
  before_action :fetch_edition, only: %w[edit create]

  def edit
  end

  def create
    Rails.logger.warn('coolness, in the children controller create')

    parent_document_id = params[:document]
    parent_edition = @edition

    Rails.logger.warn("parent document: #{parent_document_id}")
    Rails.logger.warn("parent edition: #{parent_edition.inspect}")

    new_document = create_document(parent_edition.document_type.id)
    create_timeline_entry(new_document)

    parent_edition.children << new_document # presumably will fail on save will need new revision creation

    Rails.logger.warn("new child document: #{new_document}")

    redirect_to content_path(new_document)
  end

private

  def fetch_edition
    @edition = Edition.find_current(document: params[:document])
    assert_edition_state(@edition, &:editable?)
  end

  def create_document(document_type_id)
    CreateDocumentService.call(
      document_type_id:, tags: default_tags, user: current_user,
    )
  end

  def create_timeline_entry(document)
    TimelineEntry.create_for_status_change(entry_type: :created,
                                           status: document.current_edition.status)
  end

  def default_tags
    current_user.organisation_content_id ? { primary_publishing_organisation: [current_user.organisation_content_id] } : {}
  end

end
