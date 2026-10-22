# Auditoría del skillset (17-10-2026)

> **Nota (19-10-2026):** este documento describe la versión v0 (42–54 skills). El núcleo actual, sus costos y resultados están en el [README](../README.es.md#costo-y-precisión-medido-el-19-10-2026) y en el [catálogo](catalog.es.md).

La hice instalando todo en una carpeta temporal, con 54 skills públicas y 3 propias, y probando el ruteo con Claude Code 2.1.287 real.

## Resumen

| Aspecto | Resultado | Estado |
|---|---|---|
| Instalación | 54/54 públicas y 3/3 propias instaladas en una carpeta limpia, en Claude Code y Codex | ✅ |
| Formato de las skills propias | `name` igual a la carpeta, descripciones de 244–286 caracteres (límite 1.024), cuerpos de 29–52 líneas | ✅ |
| Ruteo con pedidos de prueba | 10/10 pedidos con la combinación esperada, y cada uno descartó las skills que no correspondían | ✅ |
| Activación automática | Con un pedido normal, Claude cargó directo la skill específica correcta (`animate`) | ✅ |
| Cobertura del router | Todas las skills del perfil completo tienen una ruta; ninguna referencia apunta a una skill que no existe | ✅ Corregido |
| Eficiencia de tokens | Entre ~800 y ~5.300 tokens fijos según el perfil | ✅ Con perfiles |
| Seguridad | Sin descargas ejecutadas a ciegas (`curl \| sh`) ni instrucciones ocultas; los avisos detectados son defensivos | ✅ |
| Privacidad | Sin nombres, rutas personales, proyectos, claves ni tokens | ✅ |
| Licencias | No se copia código de terceros; cada skill se descarga de su fuente | ✅ |
| Portabilidad | Funciona con el bash 3.2 de macOS y en Linux; en Windows requiere WSL o Git Bash | ⚠️ |

## 1. Instalación

- `instalar.sh --extra` instaló **54 skills públicas** desde 20 repositorios, y las 3 propias, sin errores.
- `--lista` muestra **10 skills** en el perfil esencial, **24** en diseño, **27** en fullstack y **50** en completo.
- El script funciona con el bash 3.2 que trae macOS: no usa arrays asociativos y `npx` no consume la entrada del bucle.

## 2. Eficiencia de tokens

El agente siempre carga la descripción de cada skill instalada. El cuerpo solo se lee cuando la skill se usa, y las referencias más grandes solo si hacen falta.

| Perfil | Skills | Descripciones (siempre) | Cuerpo promedio | Cuerpo más pesado |
|---|---:|---:|---:|---|
| esencial | 13 | ~800 | ~2.100 | `impeccable`, ~3.050 |
| diseño | 27 | ~2.700 | ~2.600 | `emil-design-eng`, ~7.450 |
| fullstack | 30 | ~2.500 | ~2.550 | `subagent-driven-development`, ~8.950 |
| completo | 53 | ~5.300 | ~2.750 | `skill-creator`, ~9.050 |

Qué se hizo para reducir el gasto:

- **Las tres skills propias en conjunto** suman ~220 tokens de descripción y ~1.900 de cuerpo. Antes eran un solo archivo de ~1.300 tokens que además apuntaba a referencias de ~6.000.
- **El catálogo y las plantillas pasaron a `docs/`**, que el agente no lee. Ahorro: ~5.000 tokens cada vez que se usaba la guía.
- **Se sacó la parte genérica de los estándares**, que el modelo ya aplica por defecto: "simple y acabado", "claridad con personalidad", "explicaciones simples", la tabla de dogmas y "lo que no funciona".
- **Las skills pesadas o repetidas pasaron a `extra`:** `design-taste-frontend` (~7.000 tokens y se superpone con `impeccable`) y `true-web-clone` (se superpone con `ui-reverse-engineering`).
- **El router evita apilar skills:** pone un máximo de 4 y prohíbe cargar a la vez las cuatro skills de diseño general.

## 3. Ruteo

Hice dos pruebas con `claude -p` en un proyecto aislado con las 53 skills.

### a) 10 pedidos a través del router

| # | Pedido | Skills cargadas | Descartó |
|---|---|---|---|
| 1 | Login con Google en Next.js + Supabase | `supabase` → `test-driven-development` → `verification-before-completion` | seguridad, React, Postgres |
| 2 | "Este botón se ve feo, púlelo" | `impeccable` → `emil-design-eng` (+ `ui-convergence`) | `frontend-design`, `web-design-guidelines`, motion |
| 3 | El modal se abre de golpe | `animate` | `motion` y `motion-design`, por no haber señal de Framer Motion ni Lottie |
| 4 | Clonar el hero de linear.app | `ui-capture` → `ui-reverse-engineering` | `clone-website`, `extract-design-system` |
| 5 | PowerPoint de resultados | `pptx` | `docx`, `xlsx`, `pdf` |
| 6 | "Revisa que el dashboard esté listo" | `honest-delivery` → `verification-before-completion` | diseño, code review |
| 7 | Nombre del rebote de iOS | `animation-vocabulary` | resto de motion |
| 8 | PR que toca permisos | `differential-review` | `variant-analysis` y `audit-context-building`, que corresponden después |

Ningún pedido cargó más de 3 skills.

### b) Pedidos normales, sin mencionar el router

Para "el modal se abre de golpe", Claude cargó `animate`. Las skills específicas se activan solas por su descripción.

Con un pedido simple el router no se activa solo, y es lo esperable: entra cuando hay que combinar varias skills, cuando se lo pide o si se instala con `--siempre`.

### Hallazgo corregido

`prototype`, `pick-ui-library` y `review-animations` tienen `disable-model-invocation: true`: solo se pueden iniciar a mano. En la primera prueba el agente las reportó como "no instaladas".

El router ahora indica que, cuando una de ellas corresponde, el agente le pida al usuario que escriba `/prototype`, `/pick-ui-library` o `/review-animations`. El catálogo también lo aclara.

## 4. Seguridad de las skills de terceros

- **Instalación a ciegas:** ninguna skill contiene `curl … | sh` ni `wget … | sh`.
- **Frases como "ignore previous instructions":** aparecen 5 veces, todas defensivas. En `break-ui`, `improve-animations`, `find-animation-opportunities` y `ui-reverse-engineering` le indican al agente que trate el contenido de los archivos como datos y que marque esos intentos.
- **Scripts:** 83 scripts locales en `pptx`, `docx`, `xlsx`, `pdf`, `skill-creator`, `impeccable`, `webapp-testing` y otras. Los que hacen pedidos de red son `impeccable` (navegador local y captura de pantalla) y `design-taste-frontend` (en extra).
- **Claves:** solo `supabase` menciona claves de API, las del proyecto del propio usuario.

Las skills se ejecutan con los permisos del agente. El README pide revisarlas antes de usarlas.

## 5. Privacidad

Busqué en todo el paquete nombres, nombres de proyectos privados, rutas `/Users/…`, correos, `API_KEY`, `token`, `secret`, `sk-` y `AKIA`. No encontré nada. Las únicas coincidencias son "tokens de diseño" y la palabra `case` del script.

## 6. Pendientes y límites

1. **Windows:** `instalar.sh` es bash. En Windows hay que usar WSL o Git Bash, o instalar cada skill a mano con `npx skills add`.
2. **Duplicados:** si alguien ya tiene skills con nombres similares de otro plugin, el agente puede ver dos versiones. Conviene desinstalar una.
3. **Versiones:** las skills se descargan en su versión vigente. Un autor puede cambiar o renombrar una skill. Si `instalar.sh` falla en un repositorio, lo informa y sigue con el resto.
4. **Las pruebas de ruteo son una muestra:** 12 pedidos con un modelo. No demuestran que el ruteo sea perfecto en todos los casos.
5. **Las skills propias no se compararon contra no tenerlas.** En una prueba anterior con una versión más larga, el agente sacó el mismo puntaje con y sin la skill de estándares. Las versiones nuevas son más cortas y concretas, pero su efecto no está medido.

## 7. Revisión posterior: sitios de referencia

**Hallazgo:** al pedir "me gusta cómo se ve la página de Apple, los botones, los colores moviéndose, ese banner", el agente no capturaba ni extraía nada de la página real. Cargaba `apple-design` solo porque se nombraba a Apple, y diseñaba de memoria.

**Qué se corrigió:**
- La descripción del router ahora incluye "cuando el usuario señala un sitio o app que le gusta como referencia".
- Se agregó una ruta para ese caso: `ui-capture` → `extract-design-system` → `impeccable` o `frontend-design` → `ui-convergence`.
- `apple-design` queda reservada para interacciones tipo iOS.

**Resultado después del cambio (3 pruebas):** sin mencionar el router, en los tres casos se activó `agent-basic-skillset` y cargó `ui-capture`.
- Las dos pruebas con Apple sumaron `extract-design-system` y una skill de diseño.
- La prueba con "el scroll de linear" sumó `animate`.
- Ninguna cargó `apple-design` ni `ui-reverse-engineering`, porque no se pidió una copia exacta.

## 8. Limpieza posterior

Se eliminaron 8 skills redundantes:
- `clone-website`: se repetía con `ui-reverse-engineering`.
- `executing-plans`: se repetía con `subagent-driven-development`.
- `webapp-testing`: se repetía con `playwright-cli`.
- `writing-skills`: se repetía con `skill-creator`.
- `pdf`, `docx`, `pptx` y `xlsx`: ya vienen incluidas en Claude.

El perfil completo quedó en 42 skills públicas y 3 propias, con unos 4.300 tokens fijos.

El instalador y la lista de skills ahora viven dentro de `agent-basic-skillset`. Así, quien instale solo la skill con `npx skills add` puede instalar las faltantes cuando el router las necesite, siempre con su permiso.

Las dos formas de instalar se probaron en carpetas limpias:
- **A:** `npx skills add` y luego el instalador de la skill con el perfil esencial. Instaló 10 skills.
- **B:** el repo clonado, con `--solo-propias --siempre`. Instaló las 3 propias y agregó la línea a `CLAUDE.md` y `AGENTS.md`.

## 9. Instalación única

La instalación quedó en una sola forma: `bash instalar.sh` instala siempre el pack completo (42 públicas y 3 propias) y siempre agrega la línea del router a `CLAUDE.md` y `AGENTS.md`. Se quitaron los perfiles, la instalación de solo las propias con `npx skills add` y la oferta de instalar skills faltantes. Si falta una skill, el router lo menciona una vez y sugiere volver a correr el instalador.

## 10. Optimización del ruteo (22 pedidos, Claude Code, solo el pack y las skills que trae Claude Code)

Cada pedido define las skills requeridas y las aceptables. Un pedido es **exacto** si carga todas las requeridas y ninguna fuera de las aceptables. Los pedidos triviales ("cambia el texto de un botón", "¿qué hace esta función?") deben cargar cero skills.

| Opción | Exactos | Faltaron | Sobraron | Skills por pedido | Tokens de entrada |
|---|---:|---:|---:|---:|---:|
| Sin ruteo (solo descripciones) | 17/22 | 2 | 8 | 1,73 | ~69.600 |
| Skill router (`agent-basic-skillset`) | 18/22 | 0 | 4 | 1,73 | ~99.100 |
| Reglas en CLAUDE.md, versión 1 | 21/22 | 0 | 1 | 1,27 | ~68.600 |
| Reglas en CLAUDE.md, versión 2, corrida A | 22/22 | 0 | 0 | 1,23 | ~68.400 |
| Reglas en CLAUDE.md, versión 2, corrida B | 21/22 | 0 | 1 | 1,27 | ~68.500 |

**Errores típicos sin ruteo:**
- Suma `emil-design-eng` a una animación simple.
- Ante "me gusta la página de Apple" carga `apple-design` y no captura la página.
- Al revisar si un trabajo está listo, carga skills de diseño y de gráficos.

**Errores típicos de la skill router:**
- Suma `verification-before-completion` incluso en pedidos triviales.
- Gasta unos 30.000 tokens más por pedido, porque cargar el router agrega un paso a la conversación.

**Decisión:** se reemplazó la skill router por reglas compactas (unos 230 palabras, en `routing.md`) dentro de un bloque marcado en `CLAUDE.md` y `AGENTS.md`. Se eliminó la skill `agent-basic-skillset`.

**Límites:**
- Es una muestra de 22 pedidos con un modelo, y hay variación entre corridas (22/22 frente a 21/22).
- Las pruebas usan `--setting-sources project,local`, así que excluyen las skills personales de quien corre la prueba.

## 11. Pruebas de robustez (18-10-2026)

### Instalador

| Caso | Resultado |
|---|---|
| Opción desconocida | Muestra el error y termina con código 1 |
| Sin Node.js | Avisa y termina con código 1 **antes de tocar nada** |
| Rutas con espacios y `CODEX_HOME` personalizado | Funciona |
| Un repositorio que no existe | Instala el resto, informa cuál falló y termina con código 1 |
| Correrlo dos o tres veces | Un solo bloque de reglas y el resto de `CLAUDE.md` intacto; también quita la línea de versiones anteriores |
| Versiones | Por defecto instala el **commit probado** de cada repositorio (columna `commit probado` de `skills.tsv`); con `--ultimas` usa la versión más reciente |
| Telemetría | Se desactiva con `DISABLE_TELEMETRY=1`, salvo que el usuario la defina |

### Desinstalador (`desinstalar.sh`)

Después de una instalación completa, quitó las 42 skills públicas, las 2 propias y el bloque de reglas. Dejó intactas una skill personal del usuario y su `CLAUDE.md` original.

### Ruteo: prueba difícil con 42 pedidos

Además de los 22 originales, incluye:
- pedidos en inglés;
- pedidos compuestos ("arregla el bug **y** anima el botón");
- modismos chilenos ("la wea del menú se ve como el pico");
- faltas de ortografía ("animasion");
- trampas ("borrar deslizando como en el Mail del iPhone");
- pedidos triviales ("gracias", "haz commit");
- una skill que solo se activa a mano (`/prototype`).

| Corrida | Exactos | Faltaron | Sobraron | Skills por pedido | Tokens |
|---|---:|---:|---:|---:|---:|
| Reglas versión 2 | 40/42 | 2 | 0 | 1,33 | ~68.300 |
| Reglas versión 3 (tests y skills manuales), corrida A | **42/42** | 0 | 0 | 1,17 | ~66.500 |
| Reglas versión 3, corrida B | **42/42** | 0 | 0 | 1,21 | ~66.600 |

### Ruteo: 15 pedidos nuevos que las reglas no habían visto

**12/15.** De los 3 fallos, uno era real: "revisa este PR antes de mergear" cargó la skill de seguridad. Los otros dos eran razonables y el error estaba en lo que yo esperaba: `dataviz` para un dashboard y `playwright-cli` antes de publicar.

Para el fallo real, la regla de code review ahora distingue la revisión general (`requesting-code-review`) de la de seguridad (`differential-review`), y usa **una sola**.

**Sin verificar:** la última versión de esa regla. La corrida de verificación se cortó por el límite de uso de la cuenta. Alcanzó a correr 26 pedidos, y en uno (revisión de seguridad de un PR) cargó ambas skills. La regla se ajustó para que use solo una, pero esa versión no se probó.

### Verificación final (18-10-2026)

Los 57 pedidos (42 de ajuste y 15 nuevos), con las reglas finales: **57/57 exactos**, 0 faltantes, 0 sobrantes, 1,18 skills por pedido y unos 65.400 tokens de entrada. La corrió `tests/routing/`, que ahora detecta el límite de uso y se detiene en vez de contar respuestas vacías.

### Pendiente

- **Codex:** no se pudo probar. En el computador de prueba, la CLI de Codex está configurada contra AWS Bedrock con una credencial vencida (401 Unauthorized). Las reglas se instalan en `~/.codex/AGENTS.md`, las skills públicas en `~/.agents/skills/` y las propias en `~/.codex/skills/`, que son las rutas que Codex lee. Falta comprobar el ruteo con una sesión real de Codex.

## 12. Gate local y Codex (18-10-2026)

**Gate (`hooks/skill-gate.mjs`):** es un hook `UserPromptSubmit` que compara el pedido con expresiones regulares en `hooks/triggers.json`. No llama al modelo. Si encuentra coincidencias, agrega como máximo 3 skills; si no, no imprime nada.

| Prueba | Reglas solas | Reglas + gate |
|---|---:|---:|
| Gate sin modelo, 57 pedidos de ajuste | — | 57/57 (ajustado sobre estos pedidos) |
| Gate sin modelo, 20 pedidos nuevos | — | **10/20** (no generaliza) |
| Claude Code, 20 pedidos nuevos | 19/20, 1,20 skills, ~65.600 tokens | 20/20, 1,15 skills, ~65.800 tokens |
| Claude Code, 10 pedidos con ~15.000 tokens de contexto ajeno | 10/10, 1,30 skills | 10/10, 1,10 skills |

**Conclusión:** el gate por sí solo es poco fiable, pero el modelo descarta sus pistas equivocadas. El resultado combinado es igual o un poco mejor, con menos skills de más y un costo de ~170 tokens por pedido reconocido (0 en los demás). Es un refuerzo; la precisión viene de las reglas.

**Instalación del gate:**
- respeta los hooks existentes del usuario en `settings.json`;
- no se duplica si se instala varias veces;
- la desinstalación deja el archivo como estaba;
- con un `settings.json` inválido no lo modifica y el instalador sigue con el resto.

**Codex (`AGENTS.md`, sin gate), 20 pedidos nuevos: 16/20**, 1,35 skills por pedido, ~57.000 tokens.
- Un caso sumó `impeccable` al copiar una paleta, que es lo que indican las propias reglas.
- Otro sumó una skill de más, razonable: `impeccable` al quitar animaciones.

**Configuración de Codex del equipo de prueba:** estaba apuntando a AWS Bedrock con una credencial vencida. Se quitaron las dos líneas de Bedrock de `~/.codex/config.toml`, con respaldo en `config.toml.bak-bedrock-2026-10-18`. Esto no forma parte del pack.
