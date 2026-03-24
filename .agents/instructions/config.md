---
type: agent-configuration
version: 1.0
standard: Agentic-AI-Interoperability-Alliance
---

# Agent Environment Configuration

This repository uses the **Agentic AI Interoperability Alliance** standard for managing agent capabilities and behavior.

## 📂 Reference Architecture

The agent must discover and load context by strictly following this hierarchy:

1. **`.agents/instructions/`**: Contains behavioral rules.
    * `global.md`: Base instructions that must apply to all interactions.
    * Domain-specific instructions (e.g., `backend.md`): Load only if the task scope affects those directories.

2. **`.agents/skills/`**: Contains executable capabilities (Tool-use).
    * Each subdirectory represents an **Active Skill**.
    * The agent must read the `SKILL.md` file in each subfolder to identify the `description` and activation metadata.
    * Do not load `/scripts` contents unless the skill is explicitly invoked.

3. **`.agents/resources/`** *(optional)*: Static knowledge base — create this folder when domain reference material (data schemas, style guides, coefficient tables) is needed. Do not reference it if it does not exist.

## ⚙️ Operation Protocol

* **Progressive Discovery:** Before processing a request, parse the YAML metadata in `.agents/skills/*/SKILL.md`. If a purpose match exists, notify the user: "Activating skill [skill-name]".
* **Conflict Resolution:** If multiple skills appear to match, prefer the most specific skill for the user request. If ambiguity remains after reading the metadata, ask the user which workflow to apply.
* **Context Isolation:** Do not mix instructions from different domain files unless the task is cross-cutting.
* **Precedence:** Local instructions in the agent folder take priority over generic IDE system instructions.

---

> **Note for the Agent:** If a `SKILL.md` file is missing from a skills subfolder, notify the user to maintain standard integrity.
