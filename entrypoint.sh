#!/bin/sh

# Start MediaMTX (RTSP server) in the background
# MediaMTX provides Real-Time Streaming Protocol functionality
/mediamtx &

# Wait for MediaMTX to fully initialize
# This delay ensures the RTSP server is ready to accept connections
sleep 5

# Start FFmpeg to stream video to the RTSP server
# Parameters:
#   -re              = Read input at native frame rate (real-time)
#   -stream_loop -1  = Loop the input file indefinitely
#   -i               = Input file path
#   -c:v libx264     = Use H.264 video codec
#   -preset ultrafast = Use fastest encoding preset (reduces quality but lowers latency)
#   -tune zerolatency = Optimize for minimal latency
#   -c:a copy        = Copy audio stream without re-encoding
#   -f rtsp          = Output format is RTSP
#   -rtsp_transport tcp = Use TCP (more reliable than UDP) for RTSP transport
ffmpeg -re -stream_loop -1 -i /videos/rickroll.mp4 -c:v libx264 -preset ultrafast -tune zerolatency -c:a copy -f rtsp -rtsp_transport tcp rtsp://localhost:8554/mystream
