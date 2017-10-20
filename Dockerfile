FROM centos:latest
MAINTAINER Paul Badcock <paul@bad.co.ck>
LABEL Description="This is a CentOS with ruby, git, ruby-devel and Docker installed"

RUN yum install -y rubygems git ruby-devel docker
RUN gem install --no-ri --no-rdoc bundle
