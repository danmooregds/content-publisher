module FileAttachmentHelper
  def file_attachment_preview_url(attachment_revision, document)
    service = PreviewAuthBypass.new(document)
    params = { token: service.preview_token }.to_query
    attachment_revision.asset_url + "?" + params
  end

  def file_attachment_attributes(attachment_revision, edition)
    attributes = {
      id: attachment_revision.filename,
      title: attachment_revision.title,
      filename: attachment_revision.filename,
      content_type: attachment_revision.content_type,
      file_size: attachment_revision.byte_size,
      number_of_pages: attachment_revision.number_of_pages,
      url: preview_file_attachment_path(edition.document, attachment_revision.file_attachment),
    }

    if edition.document_type.attachments.featured?
      attributes.merge!(
        unique_reference: attachment_revision.unique_reference,
      )
    end

    attributes.compact
  end
end
