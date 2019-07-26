# frozen_string_literal: true

class ContactsController < ApplicationController
  def search
    @edition = Edition.find_current(document: params[:document])
    assert_edition_state(@edition, &:editable?)
    assert_edition_access(@edition, current_user)
    @contacts_by_organisation = ContactsService.new.all_by_organisation
    render layout: rendering_context
  rescue GdsApi::BaseError => e
    GovukError.notify(e)
    render "search_api_down", status: :service_unavailable
  end
end
