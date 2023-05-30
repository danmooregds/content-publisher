class DocumentType::TitleAndBasePathField
  include DocumentType::ListableField

  TITLE_MAX_LENGTH = 300

  def top_level_field?
    true
  end

  def as_list_items(edition:, content:)
    [ as_list_item(edition:, content:) ]
  end

  def list_content_fields
    [self]
  end

  def id
    "title_and_base_path"
  end

  def payload(edition, payload_context)
    routes = [
      { path: edition.base_path, type: "exact" },
    ]

    if edition.contents['parts']
      edition.contents['parts'].each do |part|
        routes.push({ path: edition.base_path + "/#{part['part_title'].parameterize}", type: "exact" })
      end
    end

    payload_context.deep_merge!({
      base_path: edition.base_path,
      title: edition.title,
      routes: routes,
    })
  end

  def updater_params(edition, params)
    title = params[:title]&.strip
    base_path = GenerateBasePathService.call(edition, title:)
    { title:, base_path: }
  end

  def form_issues(edition, params)
    issues = Requirements::CheckerIssues.new

    if params[:title].blank?
      issues.create(:title, :blank)
    end

    if params[:title].to_s.size > TITLE_MAX_LENGTH
      issues.create(:title, :too_long, max_length: TITLE_MAX_LENGTH)
    end

    if params[:title].to_s.lines.count > 1
      issues.create(:title, :multiline)
    end

    begin
      if base_path_conflict?(edition, params)
        issues.create(:title, :conflict)
      end
    rescue GdsApi::BaseError => e
      GovukError.notify(e)
    end

    issues
  end

  def preview_issues(edition)
    issues = Requirements::CheckerIssues.new
    issues.create(:title, :blank) if edition.title.blank?
    issues
  end

  def publish_issues(_edition)
    Requirements::CheckerIssues.new
  end

private

  def base_path_conflict?(edition, params)
    base_path_owner = GdsApi.publishing_api.lookup_content_id(
      base_path: params[:base_path],
      with_drafts: true,
      exclude_document_types: [],
      exclude_unpublishing_types: [],
    )

    base_path_owner && base_path_owner != edition.content_id
  end
end
