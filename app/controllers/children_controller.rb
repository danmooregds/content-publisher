# frozen_string_literal: true

class ChildrenController < ApplicationController
  def edit
    fetch_edition
  end

  def create
    fetch_edition
    redirect_to new_document_path(type: edition.document_type.id)
  end

private

  def fetch_edition
    @edition = Edition.find_current(document: params[:document])
    assert_edition_state(@edition, &:editable?)
  end
end
