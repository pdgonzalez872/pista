#!/bin/bash

# Function to detect the OS and return the correct command
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # MacOS
    echo "fly"
  else
    # Linux or other Unix-like OS
    echo "$HOME/.fly/bin/flyctl"
  fi
}
