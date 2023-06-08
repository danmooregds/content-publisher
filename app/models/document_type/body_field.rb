class DocumentType::BodyField
  def id
    "body"
  end

  def children_list_html(edition)

    list_items = edition.children.map do |child|
      child_edition = child.current_edition
      "<li><a href=\"#{child_edition.base_path}\">#{child_edition.title}</a></li>"
    end.join("\n")

    "<ul>#{list_items}</ul"
  end

  def payload(edition)
    {
      details: {
        body: GovspeakDocument.new(edition.contents[id], edition).payload_html + children_list_html(edition),
      },
    }
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
