#!/bin/bash

# Ensure a label is provided
if [ -z "$1" ]; then
  echo "❌ Error: Missing label parameter."
  echo "Usage: $0 \"<LABEL>\""
  exit 1
fi

LABEL="$1"


echo "🚀 Rami Demo Script to fetch git and then comming and push local changes to Git Repo"

# Run Git commands
echo "🔄 Pulling latest changes..."
git pull || { echo "❌ git pull failed"; exit 1; }

echo "➕ Adding changes..."
git add .

echo "✅ Committing with label: $LABEL"
git commit -m "Rami Live Demo - $LABEL" || { echo "❌ git commit failed"; exit 1; }

echo "🚀 Pushing to remote..."
git push || { echo "❌ git push failed"; exit 1; }

echo "🎉 Successfully pushed with label: $LABEL"