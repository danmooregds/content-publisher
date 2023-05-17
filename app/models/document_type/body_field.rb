class DocumentType::BodyField
  def add_content_fields(fields)
    fields.push(self)
  end

  def id
    "body"
  end

  def payload(edition, payload_context, contents)
    payload_context.deep_merge! body: GovspeakDocument.new(contents[id], edition).payload_html
  end

  def updater_params(_edition, params)
    { contents: { body: params[:body] } }
  end

  def form_issues(edition, params)
    issues = Requirements::CheckerIssues.new

    unless GovspeakDocument.new(params[:contents][:body], edition).valid?
      issues.create(id, :invalid_govspeak)
    end

    issues
  end

  def preview_issues(_edition)
    Requirements::CheckerIssues.new
  end

  def publish_issues(edition)
    issues = Requirements::CheckerIssues.new
    issues.create(id, :blank) if edition.contents[id].blank?
    issues
  end
end
