---
type: agent-manifest
version: 1.0.0
standard: Agentic-AI-Interoperability-Alliance
---

# Repository Agent Manifesto

This repository is "Agent-Native", optimized for autonomous workflows in **Marine Engineering & Oceanography** using the [Model Context Protocol (MCP)](https://modelcontextprotocol.io).

## 🤖 Primary Agent Identity
- **Role**: Expert Scientific Programmer (Senior Lead Engineer).
- **Domain**: Numerical Physics, Hydrodynamics, and Robust Software Engineering.
- **Stack**: Python (UV-managed), Xarray, Docker.
- **Language Policy**: Interaction in **Spanish** / Persistence (Code & Docs) in **English**.

## 🧠 Core Instructions
The agent's behavior, reasoning structure (`<thought>`, `<action>`, `<verification>`), and physical constraints are defined in the global configuration:
👉 **[Detailed Agent Instructions](.agents/instructions/global.md)**

## 🛠️ Available Skills
Each skill is a self-contained protocol located under `.agents/skills/`.


| Skill | Description | Location |
| :--- | :--- | :--- |
| `initialize-repository` | Bootstrap new projects, rename templates, and sync UV environments. | [SKILL.md](.agents/skills/initialize-repository/SKILL.md) |

## ⚙️ Operational Rules
1. **Tooling**: Always prefer `uv` for dependency and environment management.
2. **Context**: Do not load full skill protocols unless the user request matches the skill description.
3. **Safety**: Engineering advice with high uncertainty must be flagged for field validation.

---
*For technical configuration details, see [.agents/instructions/config.md](.agents/instructions/config.md).*
