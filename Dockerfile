ARG ruby_version=3.1.2
ARG base_image=ghcr.io/alphagov/govuk-ruby-base:$ruby_version
ARG builder_image=ghcr.io/alphagov/govuk-ruby-builder:$ruby_version


FROM $builder_image AS builder

ENV JWT_AUTH_SECRET=unused_yet_required \
    SECRET_KEY_BASE=unused_yet_required

WORKDIR $APP_HOME
COPY Gemfile* .ruby-version ./
RUN bundle install
COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile --non-interactive --link-duplicates
COPY . .
RUN bootsnap precompile --gemfile .
RUN rails assets:precompile && rm -fr log


FROM $base_image
RUN install_packages imagemagick

ENV GOVUK_APP_NAME=content-publisher

WORKDIR $APP_HOME
COPY --from=builder $BUNDLE_PATH/ $BUNDLE_PATH/
COPY --from=builder $BOOTSNAP_CACHE_DIR/ $BOOTSNAP_CACHE_DIR/
COPY --from=builder $APP_HOME ./

USER app
CMD ["puma"]
