FROM centos:latest
MAINTAINER Paul Badcock <paul@bad.co.ck>
LABEL Description="This is a CentOS with ruby, git, ruby-devel and Docker installed"

ENV RUBY_MAJOR 2.4
ENV RUBY_VERSION 2.4.1
ENV BUNDLER_VERSION 1.15.4
ENV RUBYGEMS_VERSION 2.6.13

RUN \
     yum -y groupinstall --setopt=tsflags=nodocs 'Development Tools' \
     && yum -y update \
     && yum -y install --setopt=tsflags=nodocs \
     libyaml-devel \
     openssl \
     openssl-devel \
     gdbm-devel \
     libffi-devel \
     gmp-devel \
     readline-devel \
     wget \
     docker \
     && yum clean all \
     && wget https://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz \
     && tar xzf ruby-$RUBY_VERSION.tar.gz -C /usr/src \
     && cd /usr/src/ruby-$RUBY_VERSION \
     && CFLAGS="-O3 -fPIC -fno-strict-aliasing" ./configure --disable-install-doc --enable-shared --enable-pthread \
     && make \
     && make install \
     && cd / \
     && rm -rf /usr/src/ruby-$RUBY_VERSION \
     && rm -rf /ruby-$RUBY_VERSION.tar.gz \
     && gem update --system "$RUBYGEMS_VERSION" \
     && gem install bundler --version "$BUNDLER_VERSION" \
     && yum clean all
     && rm -rf /var/cache/yum

ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
    BUNDLE_BIN="$GEM_HOME/bin" \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH

RUN \
     mkdir -p "$GEM_HOME" "$BUNDLE_BIN" \
     && chmod 777 "$GEM_HOME" "$BUNDLE_BIN"
