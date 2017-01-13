FROM ubuntu:14.04

MAINTAINER Owen Ouyang<owen.ouyang@live.com>

# Sets language to UTF8 : this works in pretty much all cases
ENV LANG="en_US.UTF-8" \
    DOCKER_ANDROID_LANG=en_US \
    DOCKER_ANDROID_DISPLAY_NAME=mobileci-docker \
    DEBIAN_FRONTEND=noninteractive \
    ANDROID_COMPONENTS=platform-tools,android-21,android-23,android-24,build-tools-23.0.2,build-tools-21.1.2,build-tools-24.0.0 \
    ANDROID_HOME=/opt/android-sdk-linux \
    ANDROID_SDK_HOME=/opt/android-sdk-linux \
    ANDROID_NDK_HOME=/usr/local/android-ndk \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/ \
    TERM=dumb \
    JAVA_OPTS="-Xms512m -Xmx1024m" \
    GRADLE_OPTS="-XX:+UseG1GC -XX:MaxGCPauseMillis=1000"

RUN locale-gen $LANG && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get install -y \
  autoconf \
  build-essential \
  bzip2 \
  curl \
  gcc \
  git \
  groff \
  lib32stdc++6 \
  lib32z1 \
  lib32z1-dev \
  lib32ncurses5 \
  lib32bz2-1.0 \
  libc6-dev \
  libgmp-dev \
  libmpc-dev \
  libmpfr-dev \
  libxslt-dev \
  libxml2-dev \
  m4 \
  make \
  ncurses-dev \
  ocaml \
  openssh-client \
  pkg-config \
  python-software-properties \
  rsync \
  software-properties-common \
  unzip \
  wget \
  zip \
  zlib1g-dev \
  --no-install-recommends && \
  \
  apt-add-repository ppa:openjdk-r/ppa && \
  apt-get update  apt-get -y install openjdk-8-jdk && \
  \
  rm -rf /var/lib/apt/lists/* && \
  apt-get clean && \
  \
  wget -o android-sdk.tgz http://dl.google.com/android/android-sdk_r24.3-linux.tgz && \
  tar -xvzf android-sdk.tgz && \
  mv android-sdk-linux /opt/android-sdk-linux && \
  rm android-sdk.tgz && \
  echo y | /usr/local/android-sdk/tools/android update sdk --filter "${ANDROID_COMPONENTS}" --no-ui -a && \
  wget http://dl.google.com/android/repository/android-ndk-r12-linux-x86_64.zip && \
  unzip android-ndk-r12-linux-x86_64.zip && \
  mv android-ndk-r12 /usr/local/android-ndk && \
  rm android-ndk-r12-linux-x86_64.zip && \
  apt-get clean && \
  chown -R $RUN_USER:$RUN_USER $ANDROID_HOME $ANDROID_SDK_HOME $ANDROID_NDK_HOME && \
  chmod -R a+rx $ANDROID_HOME $ANDROID_SDK_HOME $ANDROID_NDK_HOME && \
  echo "sdk.dir=$ANDROID_HOME" > local.properties

# Add build user account, values are set to default below
#ENV RUN_USER mobileci
#ENV RUN_UID 5089

#RUN id $RUN_USER || adduser --uid "$RUN_UID" \
#    --gecos 'Build User' \
#    --shell '/bin/sh' \
#    --disabled-login \
#    --disabled-password "$RUN_USER"

#WORKDIR $PROJECT

#USER $RUN_USER
#RUN echo "sdk.dir=$ANDROID_HOME" > local.properties
