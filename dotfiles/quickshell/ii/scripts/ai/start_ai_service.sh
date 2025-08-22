#!/usr/bin/env bash
# Start the Ollama service if it's not already running
if ! pgrep -x "ollama" > /dev/null; then
  ollama serve &
  sleep 2
fi

# Keep the script running to maintain the service
while true; do
  sleep 60
done
