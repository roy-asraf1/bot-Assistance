#!/bin/bash
# BMAD Workspace Installer for OpenClaw
# Run: bash install.sh

WORKSPACE="$HOME/.openclaw/workspace"

echo "🦞 Installing BMAD workspace to OpenClaw..."

# Backup existing workspace
if [ -d "$WORKSPACE" ]; then
  echo "📦 Backing up existing workspace to ${WORKSPACE}.backup"
  cp -r "$WORKSPACE" "${WORKSPACE}.backup"
fi

# Copy all files
mkdir -p "$WORKSPACE/agents"
mkdir -p "$WORKSPACE/docs/stories"
mkdir -p "$WORKSPACE/docs/ux"

cp SOUL.md "$WORKSPACE/"
cp USER.md "$WORKSPACE/"
cp AGENTS.md "$WORKSPACE/"
cp MEMORY.md "$WORKSPACE/"
cp agents/*.md "$WORKSPACE/agents/"

echo ""
echo "✅ BMAD workspace installed successfully!"
echo ""
echo "📁 Files installed to: $WORKSPACE"
echo ""
echo "🤖 Available agents:"
echo "  /analyst  → Mary   (Business Analyst)"
echo "  /pm       → John   (Product Manager)"
echo "  /architect→ Winston (Architect)"
echo "  /sm       → Bob    (Scrum Master)"
echo "  /dev      → Amelia (Developer)"
echo "  /qa       → Quinn  (QA)"
echo "  /ux       → Sally  (UX Designer)"
echo ""
echo "🚀 Now restart OpenClaw: openclaw restart"
