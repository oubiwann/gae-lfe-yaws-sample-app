FROM lfex/lfe

ENV APP_DIR /opt/sample-app
ENV APP_REPO https://github.com/oubiwann/gae-lfe-yaws-sample-app.git
ENV APP_LOG_DIR /var/log/app_engine/custom_logs

ENV DEPS_DIR $APP_DIR/deps
ENV YAWS_DIR $DEPS_DIR/yaws
ENV YAWS_APP_ID sampleapp
ENV LFE_DEPS $DEPS_DIR/lutil:$DEPS_DIR/exemplar:$DEPS_DIR/lfest
ENV DEPS $YAWS_DIR:$LFE_DEPS:$DEPS_DIR/ibrowse
ENV ERL_LIBS $ERL_LIBS:/opt/erlang/lfe:$DEPS

RUN apt-get update && apt-get install -y \
        libpam0g-dev

RUN git clone $APP_REPO $APP_DIR && \
        cd $APP_DIR && \
        rebar compile

RUN mkdir -p $APP_LOG_DIR

EXPOSE 5099

CMD sh -c "/opt/sample-app/bin/daemon;while true; do sleep 10; done"
