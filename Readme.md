Doom3Quest Docker Builder

A Docker-based build environment for "Team Beef Studios' Doom3Quest" (https://github.com/Team-Beef-Studios/Doom3Quest).

This project uses Ubuntu, the Android SDK, and Gradle to compile Doom3Quest using "assembleDebug" and export the generated APK.

Features

- Ubuntu latest base image
- Automated checkout of the Doom3Quest source
- Android SDK command-line tools
- Gradle "assembleDebug" compilation
- APK export to an "output/" directory
- Upstream commit information included with the build

Requirements

- Docker Engine or Docker Desktop
- GitHub access and an internet connection
- Sufficient disk space for the Android SDK and build dependencies

Repository structure

Doom3Quest-Docker-Builder/
├── Dockerfile
├── README.md
└── output/

The "output/" directory is created when running the container and should be used for build artifacts.

Build instructions

1. Clone your repository

git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
cd YOUR_REPOSITORY

Replace "YOUR_USERNAME" and "YOUR_REPOSITORY" with your GitHub details.

2. Build the Docker image

docker build --pull --no-cache -t doom3quest-builder .

This installs the build dependencies, downloads Doom3Quest's source code, and runs:

./gradlew assembleDebug --no-daemon

The "--no-cache" option ensures Docker does not reuse cached build steps.

3. Export the APK

Create the local output directory:

mkdir -p output

Run the container:

docker run --rm \
  -v "$(pwd)/output:/output" \
  doom3quest-builder

The generated APK should be available in "output/".

Expected layout:

output/
├── app-debug.apk
└── upstream-commit.txt

The APK filename depends on the upstream project's Gradle configuration.

Updating Doom3Quest

To fetch the latest upstream source and recompile, rebuild the image:

docker build --pull --no-cache -t doom3quest-builder .

Then run the container again to export the newly compiled APK.

Note: The Dockerfile does not continuously monitor GitHub. You must rebuild the image to check for and compile upstream changes.

Build configuration

The Dockerfile currently uses:

- Base image: "ubuntu:latest"
- Java: OpenJDK 17
- Android SDK platform: API 35
- Android Build Tools: 35.0.0
- Gradle task: "assembleDebug"

These versions may need to be adjusted to match Doom3Quest's current Android Gradle Plugin, SDK, NDK, and native build requirements.

Troubleshooting

Build fails during Gradle configuration

Check the upstream Gradle files for the required Java version, Android Gradle Plugin version, and SDK configuration.

Android SDK or NDK errors

Install the SDK platform, NDK, or CMake version required by the current upstream project.

No APK appears in "output/"

Review the build logs and verify the APK output path. If the upstream project changes its module names or build variants, update the APK export command in the Dockerfile.

Need a fresh build?

Use:

docker build --pull --no-cache -t doom3quest-builder .

Disclaimer

This is an independent community build setup and is not affiliated with or endorsed by Team Beef Studios. Doom3Quest and its source code remain the property of their respective authors. Please follow the upstream project's license when redistributing source code or compiled builds.
