
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"

RUN apt-get update && apt-get install -y \
    git curl wget unzip zip ca-certificates \
    openjdk-17-jdk build-essential cmake ninja-build \
    pkg-config python3 file \
    && rm -rf /var/lib/apt/lists/*

# Install Android command-line tools
RUN mkdir -p "${ANDROID_HOME}/cmdline-tools" && \
    wget -q \
      https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
      -O /tmp/android-tools.zip && \
    unzip -q /tmp/android-tools.zip -d "${ANDROID_HOME}/cmdline-tools" && \
    mv "${ANDROID_HOME}/cmdline-tools/cmdline-tools" \
       "${ANDROID_HOME}/cmdline-tools/latest" && \
    rm /tmp/android-tools.zip

# Install Android SDK components
RUN yes | sdkmanager --licenses >/dev/null 2>&1 || true
RUN sdkmanager \
    "platform-tools" \
    "platforms;android-35" \
    "build-tools;35.0.0" \
    "cmake;3.22.1"

WORKDIR /workspace

# Always fetch current upstream source when this Docker layer is rebuilt
RUN git clone --depth 1 \
    https://github.com/Team-Beef-Studios/Doom3Quest.git Doom3Quest

WORKDIR /workspace/Doom3Quest

RUN chmod +x gradlew && \
    ./gradlew assembleDebug --no-daemon && \
    mkdir -p /output && \
    find . -type f \
      -path "*/build/outputs/apk/debug/*.apk" \
      -exec cp {} /output/ \; && \
    git rev-parse HEAD > /output/upstream-commit.txt && \
    test -n "$(find /output -maxdepth 1 -name '*.apk' -print -quit)"

VOLUME ["/output"]

CMD ["sh", "-c", "ls -lh /output"]
