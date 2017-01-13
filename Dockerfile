FROM frekele/gradle:3.2.1-jdk8

MAINTAINER Owen Ouyang<owen.ouyang@live.com>

# Install Git and dependencies
RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y git libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists /var/cache/apt

# Install Android SDK
ENV ANDROID_HOME="/opt/android-sdk-linux" \
    PATH="${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools" \
    SDK_URL="https://dl.google.com/android/repository/tools_r25.2.3-linux.zip" \
    ANDROID_COMPONENTS=platform-tools,android-15,android-23,android-21,android-24,build-tools-23.0.2,build-tools-24.0.0,build-tools-21.1.2,build-tools-25.0.2

RUN mkdir -p $ANDROID_HOME \
 && cd $ANDROID_HOME \
 && curl -o sdk.zip $SDK_URL \
 && unzip sdk.zip \
 && rm sdk.zip \
 && echo y | /opt/android-sdk-linux/tools/android update sdk --filter "${ANDROID_COMPONENTS}" --no-ui -a

# COPY ./licenses $ANDROID_HOME/licenses



