FROM darthjee/production_ruby_270:1.1.0 as base
FROM darthjee/scripts:0.3.1 as scripts

######################################

FROM base as builder

ADD source/Gemfile* /home/app/app/

ENV HOME_DIR /home/app

COPY --chown=app:app --from=scripts /home/scripts/builder/bundle_builder.sh /usr/local/sbin/bundle_builder.sh
RUN /bin/bash bundle_builder.sh --without development test

#######################
#FINAL IMAGE
FROM base

COPY --chown=app:app --from=builder /home/app/bundle/ /usr/local/bundle/

CMD ["ruby", "app.rb"]
