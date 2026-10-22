# Catálogo de skills

Este archivo es para personas: el agente no lo lee. Cada skill pública viene del repositorio de su autor, fijada en [`manifest/skills.tsv`](../manifest/skills.tsv). No hace falta nombrar la skill: describe la tarea y las reglas de ruteo eligen. "Pídelo así" muestra una frase que la activa.

"Cuerpo" son los tokens aproximados que se cargan solo cuando la skill se usa. En Claude Code el pack muestra cada skill solo por su nombre, así que una skill que no se usa cuesta unos 8 tokens por mensaje.

## Núcleo (se instala por defecto)

### Propias

| Skill | Qué hace | Cuándo se carga | Cuerpo |
|---|---|---|---:|
| `ui-convergence` | Lleva la lista conservar / corregir / pendiente / fuera de alcance y convierte el feedback visual en comprobaciones: explora → refina → converge | Iterando una UI con feedback | ~480 |
| `honest-delivery` | Que lo que muestra la UI sea verdad y que se revise la experiencia real antes de decir "listo" | Al mostrar progreso, resultados o demos, o al cerrar | ~430 |

### Diseño e interfaz

| Skill | Qué hace | Pídelo así | Cuerpo |
|---|---|---|---:|
| `impeccable` (pbakaus) | Diseña, critica, pule y audita interfaces, también páginas nuevas | "Pule esta pantalla" / "Hazme una landing para X" | ~3.100 |
| `apple-design` (Emil Kowalski) | Movimiento e interacción estilo Apple: gestos, springs, sheets | "Quiero que esto se sienta como en iOS" | ~6.200 |
| `pick-ui-library` (Emil Kowalski) | Elige la librería de componentes adecuada | Escribe `/pick-ui-library` (solo a mano) | ~1.200 |
| `prototype` (Emil Kowalski) | Varias versiones de una pieza de UI con un selector en vivo | Escribe `/prototype` (solo a mano) | ~2.100 |

### Motion (Emil Kowalski)

| Skill | Qué hace | Pídelo así | Cuerpo |
|---|---|---|---:|
| `animate` | Construye una animación en el orden correcto: propósito, propiedades, curva, duración | "Anima la apertura de este modal" | ~3.100 |
| `animation-performance` | Animaciones fluidas, sin jank | "Esta animación se traba" | ~3.600 |
| `review-animations` | Critica una animación existente | Escribe `/review-animations` (solo a mano) | ~2.300 |

### Referencias visuales y clonado

| Skill | Qué hace | Pídelo así | Cuerpo |
|---|---|---|---:|
| `ui-capture` (voidmatcha) | Captura la referencia en vivo: screenshots, scroll, hover, clics, grabaciones | "Captura cómo se comporta el hero de este sitio" | ~2.100 |
| `ui-reverse-engineering` (voidmatcha) | Recrea una URL o sección en React + Tailwind | "Clona esta sección de linear.app" | ~4.000 |
| `extract-design-system` (arvindrk) | Saca colores, tipografías y espaciados de un sitio | "Saca el design system de esta web" | ~530 |

### Código y datos

| Skill | Qué hace | Pídelo así | Cuerpo |
|---|---|---|---:|
| `vercel-react-best-practices` | Reglas de rendimiento para React y Next.js | "¿Por qué esta página se re-renderiza tanto?" | ~1.900 |
| `vercel-composition-patterns` | Composición de componentes React | "Este componente tiene demasiados props" | ~700 |
| `supabase` | Supabase: auth, base de datos, storage | "Conecta esto a Supabase" | ~3.700 |
| `supabase-postgres-best-practices` | Esquemas, índices, RLS y migraciones | "Diseña el esquema y las políticas RLS" | ~500 |

### Pruebas y revisión

| Skill | Qué hace | Pídelo así | Cuerpo |
|---|---|---|---:|
| `playwright-cli` (Microsoft) | Controla un navegador desde la terminal | "Abre la app y prueba el checkout" | ~4.200 |
| `differential-review` (Trail of Bits) | Revisión de seguridad enfocada en un diff | "Revisa la seguridad de este PR" | ~1.900 |

Para una revisión de PR normal se usa el `/code-review` que trae Claude Code, no una skill del pack.

## Opcionales (`bash install.sh --extra`)

Nunca o casi nunca hicieron falta en las pruebas de ruteo, son pesadas o de nicho. Al instalarlas también se agrega su línea de ruteo.

| Skill | Qué hace | Por qué es opcional |
|---|---|---|
| `emil-design-eng` (Emil Kowalski) | Criterio de pulido de componentes y detalles invisibles | Cuerpo de ~7.500 tokens; se superpone con `impeccable` |
| `break-ui` (Emil Kowalski) | Prueba la UI con datos extremos | Nicho |
| `find-animation-opportunities` (Emil Kowalski) | Encuentra dónde falta movimiento | Nicho; solo da consejos |
| `improve-animations` (Emil Kowalski) | Auditoría y plan de motion de todo el proyecto | Nicho |
| `animation-vocabulary` (Emil Kowalski) | Le pone nombre a un efecto descrito de forma vaga | Se pide poco; cuerpo de ~3.500 tokens |
| `motion` (Motion) | Uso correcto de Motion / Framer Motion | Solo para proyectos con Motion |
| `audit-context-building` (Trail of Bits) | Arma el contexto de un repo antes de auditar | Para especialistas en seguridad |
| `variant-analysis` (Trail of Bits) | Busca variantes de una vulnerabilidad ya encontrada | Para especialistas en seguridad |
| `property-based-testing` (Trail of Bits) | Pruebas por propiedades para lógica con muchos casos borde | Nicho |
| `true-web-clone` | Clonado fiel de un sitio | Se superpone con `ui-reverse-engineering` |
| `design-taste-frontend` (Leonxlnx) | Reglas de buen gusto para frontend | Cuerpo de ~7.000 tokens; se superpone con `impeccable` |
| `extract-design` (dembrandt) | Tokens W3C con el CLI Dembrandt | Requiere instalar `dembrandt` |
| `reverse-engineer-anything` (REA) | Ingeniería inversa de binarios, apps Electron y firmware | Para software compilado; ~6.000 tokens |

## Quitadas en esta versión

Están en [`manifest/retired.txt`](../manifest/retired.txt). `bash uninstall.sh --retired` las borra de una instalación anterior.

| Skill | Por qué |
|---|---|
| `writing-plans`, `subagent-driven-development`, `dispatching-parallel-agents`, `using-git-worktrees`, `finishing-a-development-branch` | Claude Code ya planifica y usa subagentes y worktrees por su cuenta |
| `test-driven-development`, `receiving-code-review`, `verification-before-completion` | Los modelos actuales lo hacen bien sin ayuda; `honest-delivery` cubre la revisión final |
| `brainstorming`, `systematic-debugging` | Los modelos actuales planifican y depuran bien sin una skill de proceso; `honest-delivery` cubre la revisión final |
| `requesting-code-review` | Claude Code trae `/code-review` |
| `frontend-design` | Se superpone con `impeccable` |
| `agent-browser` | Duplica a `playwright-cli` |
| `skill-creator` | Existe como plugin oficial `skill-creator` |
| `find-skills` | La búsqueda de plugins y skills ya viene integrada |
| `web-design-guidelines` | Se superpone con `impeccable` |
| `motion-design` | Se superpone con `animate` |
