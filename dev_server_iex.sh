#!/bin/bash

MIX_ENV=dev WORKER_KIND=genserver iex -S mix phx.server
