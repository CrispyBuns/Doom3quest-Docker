Build Instructions

1. Build the Docker image

docker build --pull --no-cache -t doom3quest-builder .

2. Export the APK

Create the output directory:

mkdir -p output

Run the container:

docker run --rm \
  -v "$(pwd)/output:/output" \
  doom3quest-builder

The compiled APK will be available in the "output/" directory.

3. Rebuild after updating Doom3Quest

After updating the source code in your repository, rebuild the image:

docker build --pull --no-cache -t doom3quest-builder .

Then repeat Step 2 to export the updated APK.
