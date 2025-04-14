# Use a lightweight Debian base image to keep the image size small
FROM debian:bookworm-slim as builder

# Install FFmpeg and clean up to reduce image size
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Use the MediaMTX base image that includes FFmpeg support
FROM bluenviron/mediamtx:latest-ffmpeg

# Copy the video file into the container
COPY videos/rickroll.mp4 /videos/rickroll.mp4

# Configure MediaMTX to use TCP only for RTSP (more firewall-friendly)
ENV MTX_PROTOCOLS=tcp

# Expose RTSP port
EXPOSE 8554

# Add and make the custom entrypoint executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint script to launch MediaMTX
ENTRYPOINT ["/entrypoint.sh"]
