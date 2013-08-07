#!/bin/sh

# rails アプリケーション置き場のユーザ
MY_GROUP="ec2-user"

# rbenv でインストールするバージョン
RBENV_VERSION="1.9.3-p448"

set -eux

. /etc/profile

yum install \
    git make gcc-c++ patch \
    libyaml-devel libffi-devel libicu-devel \
    zlib-devel readline-devel \
    mysql mysql-devel sqlite sqlite-devel \
    httpd httpd-devel curl-devel

# httpd 自動起動
chkconfig /etc/init.d/httpd
chkconfig httpd on
chkconfig --list httpd
usermod -G $MY_GROUP -a apache

# rbenv インストール
cd /usr/local
git clone git://github.com/sstephenson/rbenv.git rbenv
mkdir rbenv/shims rbenv/versions
chgrp -R $MY_GROUP rbenv
chmod -R g+rwxX rbenv
git clone git://github.com/sstephenson/ruby-build.git ruby-build
cd ruby-build
./install.sh
echo 'export RBENV_ROOT="/usr/local/rbenv"'     >> /etc/profile.d/rbenv.sh
echo 'export PATH="/usr/local/rbenv/bin:$PATH"' >> /etc/profile.d/rbenv.sh
echo 'eval "$(rbenv init -)"'                   >> /etc/profile.d/rbenv.sh
. /etc/profile.d/rbenv.sh
rbenv install $RBENV_VERSION
rbenv  global $RBENV_VERSION

gem install passenger --no-ri --no-rdoc
passenger-install-apache2-module

gem install bundle --no-ri --no-rdoc
