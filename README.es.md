# Caba's Agent Skillset

Un pack chico y probado de skills públicas para desarrollar, diseñar y entregar software con **Claude Code** y **Codex**. Trae reglas de ruteo que le dicen al agente qué skill cargar en cada pedido, y ninguna en los pedidos triviales. English: [README.md](README.md).

- **Barato:** en Claude Code el pack suma cerca de **+3%** al contexto de cada mensaje (medido abajo), porque las skills se muestran solo por nombre y una tabla corta de reglas hace el ruteo.
- **Versiones fijadas:** cada skill se instala en el commit exacto con que se probó. Un bot mensual propone actualizar solo las skills cuyos archivos cambiaron.
- **Medido:** el ruteo se comprueba con pruebas repetibles (`tests/`).
- **Reversible:** `uninstall.sh` quita lo que agregó y nada más.

## Instalar

Necesitas [Node.js](https://nodejs.org) 22 o superior (para `npx`) y git.

```bash
git clone https://github.com/cabaflow/cabas-agent-skillset.git
cd cabas-agent-skillset
bash install.sh
```

Después reinicia Claude Code o Codex. El instalador:

1. Copia las 2 skills propias.
2. Descarga las 18 skills públicas del núcleo desde sus repositorios originales, cada una en su commit fijado.
3. Agrega las reglas de ruteo ([routing/rules.md](routing/rules.md), ~420 tokens) a `~/.claude/CLAUDE.md` y `~/.codex/AGENTS.md`, dentro de un bloque marcado que se reemplaza al reinstalar.
4. Solo en Claude Code: deja las skills del pack en `"name-only"` dentro de `skillOverrides` en `~/.claude/settings.json` e instala el **gate**, un hook local que sugiere skills sin llamar al modelo. No toca tus otras configuraciones, hooks ni overrides.

Opciones:

```bash
bash install.sh --list                 # ver qué se instalaría
bash install.sh --extra                # suma las 13 skills opcionales y su línea de ruteo
bash install.sh --agents claude-code   # solo Claude Code (o: codex)
bash install.sh --latest               # última versión de cada skill, no la fijada
bash install.sh --no-gate              # sin el hook del gate
bash install.sh --full-descriptions    # muestra las skills con su descripción completa (cuesta más)
```

Las opciones en español de la versión anterior (`--lista`, `--agentes`, `--ultimas`, `--sin-gate`) siguen funcionando.

**Actualizar:** `git pull` y luego `bash install.sh`. **Desinstalar:** `bash uninstall.sh` (con `--retired` también quita las skills que instalaban versiones anteriores).

## Qué incluye

20 skills en el núcleo. El detalle, el tamaño de cada una, las opcionales y las quitadas están en [docs/catalog.es.md](docs/catalog.es.md).

| Área | Skills |
|---|---|
| Propias | `ui-convergence` (iterar una UI con feedback sin perder lo aprobado), `honest-delivery` (lo que se muestra debe ser verdad; revisar la experiencia real antes de decir "listo") |
| Método | `brainstorming`, `systematic-debugging` |
| Diseño e interfaz | `impeccable`, `apple-design`, `/prototype`, `/pick-ui-library` |
| Motion | `animate`, `animation-performance`, `/review-animations` |
| Referencias y clonado | `ui-capture`, `ui-reverse-engineering`, `extract-design-system` |
| Código y datos | `vercel-react-best-practices`, `vercel-composition-patterns`, `supabase`, `supabase-postgres-best-practices` |
| Pruebas y revisión | `playwright-cli`, `differential-review` (seguridad); para revisar un PR normal se usa el `/code-review` que trae Claude Code |

Las que llevan `/` se activan solo escribiéndolas; así lo decidió su autor. En [docs/prompt-templates.es.md](docs/prompt-templates.es.md) hay 13 plantillas de pedidos frecuentes.

## Cómo funciona

Solo pides lo que necesitas. "Me gusta cómo se ve stripe.com, quiero algo así" carga `ui-capture`, `extract-design-system` e `impeccable`; "el modal se abre de golpe" carga solo `animate`; "renombra esta variable" no carga nada.

Normalmente Claude Code pone en el contexto la descripción de cada skill instalada en todos los mensajes. El pack, en cambio, muestra sus skills solo por nombre (unos 8 tokens cada una, con la opción documentada [`skillOverrides`](https://code.claude.com/docs/en/skills#override-skill-visibility-from-settings)). La tabla de reglas en `CLAUDE.md` dice cuándo usar cada una, y el cuerpo completo de una skill se lee solo cuando se usa. El costo: una skill del pack que las reglas no mencionan casi nunca se va a activar sola, porque el modelo no ve su descripción.

**El gate** es un hook `UserPromptSubmit` en Node que compara el pedido con patrones locales ([hooks/triggers.json](hooks/triggers.json)), sin llamar al modelo. Si encuentra coincidencia, agrega una línea de ~20 tokens ("Skill gate: load animate…"); si no, no agrega nada. Es un refuerzo débil (12/20 por sí solo en los 20 pedidos nuevos); el trabajo lo hacen las reglas.

## Costo y precisión (medido el 19-10-2026)

Contexto por mensaje, con `claude -p "hola"`, Claude Code 2.1.287 y solo la configuración del proyecto. La base absoluta varía un poco entre corridas (26.179–27.953 tokens), así que hay que comparar filas de la misma corrida.

| Configuración | Contexto por mensaje | vs. vacío |
|---|---:|---:|
| Vacío | 26.179 | — |
| **Núcleo, solo nombre + reglas (por defecto)** | **27.020** | **+3,2%** |
| Núcleo, descripciones completas + reglas | 29.181 | +11,5% |
| Versión anterior: 44 skills con descripción | 32.919 (base 27.953) | +17,8%, ~+19% con reglas |

Casi todo se lee de la caché. Cuando se usa una skill, ese pedido cuesta más: un paso extra y el cuerpo de la skill (entre 500 y 6.200 tokens en el núcleo).

Ruteo en Claude Code con la instalación por defecto:

| Prueba | Exactos |
|---|---:|
| `cases.json`, 57 pedidos | **55/57** (53/57 si se cuentan 2 casos que piden skills opcionales que no están en el núcleo) |
| `cases_holdout2.json`, 20 pedidos escritos después de las reglas | **19/20** |

Errores: "copia la paleta de colores de airbnb" cargó además `impeccable`; "busca más casos de este XSS" cargó `systematic-debugging` (la correcta, `variant-analysis`, es opcional); "ponle una barra de progreso a la carga" cargó `impeccable` en vez de `honest-delivery` o `animate`. En promedio, 1,05 skills por pedido y ~52.000 tokens por pedido de prueba.

Comparación anterior (22 pedidos): sin ruteo, 17/22; con una skill router, 18/22 y ~30.000 tokens más por pedido; con reglas en `CLAUDE.md`, 22/22.

**Límites, con honestidad:**
- `skillOverrides` existe solo en Claude Code. **Codex no tiene modo "solo nombre"**: paga la descripción completa de cada skill instalada (con tope del 2% de su contexto), así que el pack también se mantiene chico para Codex. Codex dio 16/20 con las reglas anteriores; en esta versión no se volvió a medir.
- El gate junto al modelo no se volvió a medir en esta versión (el gate solo da 12/20).
- Los casos de prueba los escribió el autor. Los 20 pedidos nuevos son la mejor señal de cómo generaliza, y 20 es una muestra chica.
- La ganancia frente a Claude sin ruteo es modesta (17/22 → 22/22 en la comparación anterior). El pack sirve más si todavía no sabes qué skills existen.

## Versiones fijadas y el bot de actualización

[`manifest/skills.tsv`](manifest/skills.tsv) fija cada skill a un commit. Una vez al mes, [`update-pins.yml`](.github/workflows/update-pins.yml) corre [`scripts/check-updates.py`](scripts/check-updates.py). El script compara la carpeta de cada skill entre el commit fijado y el HEAD del repositorio, ignorando los commits que tocan otras partes. Después abre un solo PR con las skills que cambiaron, enlaces al diff y las pruebas baratas (sintaxis, test del gate, instalación limpia). La prueba de ruteo no corre en CI porque necesita una cuenta de Claude; córrela antes de mergear un PR que cambie skills importantes para el ruteo. Para que el bot pueda abrir PRs, activa *Settings → Actions → General → Allow GitHub Actions to create and approve pull requests*.

## Licencias y seguridad

Este repositorio no copia código de terceros: el instalador descarga cada skill desde su repositorio original con el CLI [`skills`](https://github.com/vercel-labs/skills), con la telemetría desactivada. Cada skill mantiene la licencia de su autor (MIT, Apache-2.0, CC-BY-SA-4.0 o la que indique su repositorio). Las skills propias, las reglas, los scripts y los documentos están bajo MIT.

Las skills corren con los permisos de tu agente. Revisa una skill antes de confiar en ella; más en [SECURITY.md](SECURITY.md).
