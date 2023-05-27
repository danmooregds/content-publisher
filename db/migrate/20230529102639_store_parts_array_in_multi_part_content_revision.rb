class StorePartsArrayInMultiPartContentRevision < ActiveRecord::Migration[7.0]
  def up
    Revision.all.each do |revision|
      Rails.logger.warn('migrating a revision for doc type: |' + revision.document_type.id + '|' )
      if revision.document_type.id == 'multi_part'
        content_revision = revision.content_revision
        def content_revision.readonly?
          false
        end

        Rails.logger.warn('it is multi_part, attempting to change contents' )
        begin
          Rails.logger.warn('content revision changed before manipulation: ' + content_revision.changed?.to_s)
          single_part = content_revision.contents.delete('part')
          Rails.logger.warn('single part: ' + single_part.inspect)
          content_revision.contents['parts'] = [ single_part ]
          Rails.logger.warn('updated contents: ' + content_revision.contents.inspect)
          Rails.logger.warn('content revision changed before save: ' + content_revision.changed?.to_s)
          content_revision.save!
          Rails.logger.warn('content revision changed after save: ' + content_revision.changed?.to_s)
        rescue => e
          Rails.logger.warn('got an error updating contents: ' + e.inspect)
          raise e
        end
      end
    end
  end
end
