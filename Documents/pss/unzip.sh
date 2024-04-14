#!/usr/bin/env bash

for f in *.zip; do unzip "$f" -d "${f%.zip}"; done
