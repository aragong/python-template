---
type: agent-configuration
version: 1.0
standard: Agentic-AI-Interoperability-Alliance
---

# Configuración del Entorno del Agente

Este repositorio utiliza el estándar de la **Agentic AI Interoperability Alliance** para la gestión de capacidades y comportamiento del agente.

## 📂 Arquitectura de Referencia

El agente debe buscar y cargar contexto siguiendo estrictamente esta jerarquía:

1.  **`.agents/instructions/`**: Contiene las reglas de comportamiento.
    *   `global.md`: Instrucciones base que deben aplicarse a todas las interacciones.
    *   Instrucciones de dominio (ej. `backend.md`): Solo deben cargarse si el scope de la tarea afecta a dichos directorios.

2.  **`.agents/skills/`**: Contiene capacidades ejecutables (Tool-use).
    *   Cada subdirectorio representa una **Skill Activa**.
    *   El agente debe leer el archivo `SKILL.md` de cada subcarpeta para identificar la descripción (`description`) y los metadatos de activación.
    *   No se deben cargar los contenidos de `/scripts` a menos que se invoque explícitamente la skill.

3.  **`.agents/resources/`**: Base de conocimiento estática.
    *   Consultar estos archivos únicamente cuando se requiera información técnica específica, esquemas de datos o guías de estilo documentadas.

## ⚙️ Protocolo de Operación

*   **Descubrimiento Progresivo:** Antes de procesar una solicitud, analiza los metadatos YAML en `.agents/skills/*/SKILL.md`. Si existe una coincidencia de propósito, notifica al usuario: "Activando skill [nombre-de-skill]".
*   **Aislamiento de Contexto:** No mezcles instrucciones de diferentes archivos de dominio a menos que la tarea sea transversal.
*   **Precedencia:** Las instrucciones locales en la carpeta del agente tienen prioridad sobre las instrucciones genéricas del sistema del IDE.

---

> **Nota para el Agente:** Si detectas que falta un archivo `SKILL.md` en una subcarpeta de habilidades, informa al usuario para mantener la integridad del estándar.
