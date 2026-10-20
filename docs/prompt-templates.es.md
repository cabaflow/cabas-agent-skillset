# Plantillas de pedidos

Plantillas para los pedidos más frecuentes. English: [prompt-templates.md](prompt-templates.md). Cambia los campos entre llaves y usa solo el bloque que corresponde. No hace falta pegarlas enteras: también sirven como lista de lo que conviene decir.

## 1. Encargo compacto de producto

```text
Quiero resolver {problema} para {usuario}, en {pantalla/flujo}.
El resultado debe permitir {acción concreta} y se revisará en {app/browser/paquete}.

Lee primero {fuentes y contexto}. Conserva {decisiones aprobadas}.
Lo que hoy falla es {comportamiento observable}. El alcance es {incluido};
queda fuera {excluido}.

Conviértelo en un resultado usable con código claro. Antes de volver a
preguntarme, busca las respuestas en lo entregado. Avanza con las decisiones
reversibles autorizadas y declara cualquier suposición relevante.

Comprueba {recorrido principal y casos críticos}. Cierra indicando qué
cambió, qué verificaste, cómo abrirlo y qué sigue pendiente.
```

**Aceptación:** el flujo responde al problema y la entrega se puede comprobar en la superficie indicada. **Evitar:** «hazlo premium / nivel Apple» como único requisito.

## 2. Explorar direcciones visuales

```text
Todavía no he elegido una dirección para {superficie}.
Diseña {número acordado} opciones funcionales que resuelvan las mismas
tareas con los mismos datos.

Varía composición, jerarquía e interacción, no sólo colores. Para cada una
explica en pocas palabras qué decisión de uso mejora y qué sacrifica.
Usa {referencias} identificando los elementos concretos que adaptas.

Conserva {base aprobada, si existe}. Déjame comparar el recorrido real,
incluido movimiento y estados. Recomienda una opción con evidencia,
sin atribuirme una preferencia que aún no he expresado.
```

**Aceptación:** diferencias observables y comparables, alternativas completas al nivel acordado. **Evitar:** galerías cosméticas, elegir por el usuario o instalar muchas librerías para demostrar variedad.

## 3. Refinar después de elegir

```text
Conserva {elementos aprobados} de {versión identificada}.
Corrige {lista de observaciones}. De {otra versión}, adapta únicamente
{propiedad o comportamiento elegido}.

Construye una sola candidata coherente. No reabras decisiones cerradas
sin una razón concreta. Traduce cada observación a una comprobación y
mantén una lista breve: conservar, corregir, pendiente y fuera de alcance.

Muéstrame el resultado en {superficie} y distingue lo probado de lo que
aún requiere mi juicio visual.
```

**Aceptación:** se preserva la base y cada corrección es verificable. **Evitar:** interpretar «me gusta la barra» como aprobación de toda la página, o mantener seis versiones cuando ya se pidió converger.

## 4. Extraer y adaptar una referencia

```text
De {referencia} me interesa {elemento}, por {propiedad concreta}.
Analiza su estructura, tipografía, proporciones, estados y comportamiento.
Separa lo que observaste de lo que infieres y de lo que necesitas medir.

Adapta ese recurso a {marca/producto}; conserva nuestra tarea, contenido
y datos reales. No acumules todas las ideas del referente.

Compara referencia y candidata en condiciones equivalentes: escala,
viewport y recorrido. Explica qué se conserva, qué cambia y por qué.
```

**Aceptación:** adaptación identificable de propiedades observadas, sin inventar medidas ni promesas del producto. **Evitar:** copiar una marca completa por entusiasmo con un componente, o declarar fidelidad sin inspección.

## 5. Motion que explique y se pueda apreciar

```text
En {escena}, el usuario debe entender {idea/función}.
Hoy sucede {salto, desaparición, velocidad, descoordinación}.
Conserva {recurso aprobado} y corrige {efecto no deseado}.

Describe las fases de entrada, transición y salida, y cómo responden al
scroll/hover. Si propongo un porcentaje de velocidad, define primero si
afecta duración, distancia o relación con el gesto.

Implementa y recorre la escena a velocidad normal, lenta, rápida e inversa
cuando corresponda. Comprueba legibilidad, nitidez, continuidad y movimiento
reducido. Una captura estática no basta para cerrar este cambio.
```

**Aceptación:** se comprende el relato y se aprecia sin saltos o pérdida de legibilidad. **Evitar:** animar todos los elementos, aplicar «30%» sin definir la magnitud o inventar una comprobación visual.

## 6. Dashboard conectado a decisiones

```text
La pantalla es {inicio operativo / planificación / revisión de resultados}.
Su usuario vuelve para decidir {decisiones}, usando {datos disponibles}.

Propón una jerarquía que permita ver estado, problema y siguiente acción.
Evita duplicar otro flujo. Usa datos verificables; identifica fixtures,
supuestos y métricas que todavía no se pueden calcular.

Si comparas alternativas, define la referencia y usa condiciones
equivalentes. No muestres ahorro, factibilidad u optimalidad sin respaldo.
Mantén logs y detalles internos accesibles sólo cuando ayuden.

Comprueba estados vacíos, parciales, fallidos y válidos con el contrato actual.
```

**Aceptación:** se entiende qué hacer y por qué, con métricas honestas. **Evitar:** KPIs decorativos, confundir la home con otra pantalla, ahorro inventado o logs como contenido central.

## 7. Progreso y primera utilidad

```text
Quiero reducir la espera antes de que {producto} resulte útil.
Reconstruye el flujo real y sus fuentes de verdad: qué está descargado,
preparado, procesado y efectivamente listo.

Detecta esperas, duplicaciones y estados que confunden. Evalúa qué trabajo
puede seguir en segundo plano sin perder información ni fingir que terminó.
Mide {beneficio esperado} antes de decidir cambios grandes.

Haz que el progreso explique lo que ocurre y que pausa, reintento y
reapertura sean coherentes. Prueba las interrupciones relevantes.
```

**Aceptación:** utilidad antes, progreso verdadero y recuperación comprobada. **Evitar:** ocultar errores bajo un spinner o marcar como terminado algo sin evidencia.

## 8. Depurar sin acumular parches

```text
El fallo observable es {síntoma}; ocurre en {pasos/versión/entorno}.
Reprodúcelo y distingue síntoma, causa y alcance.

Revisa decisiones y pruebas existentes antes de agregar capas. Aplica la
corrección más simple que resuelva la causa dentro del encargo. Añade o
ejecuta comprobaciones que puedan detectar una regresión real.

Si aparecen problemas independientes, sepáralos y explica su relación.
No amplíes el producto para evitar entender este fallo. Entrega evidencia
del antes/después y de lo que todavía no se pudo reproducir.
```

**Aceptación:** causa sustentada y caso que falla antes/pasa después cuando sea viable. **Evitar:** subir límites a ciegas, ocultar mensajes, refactorizar todo o sumar tests que sólo copian la implementación.

## 9. Integrar trabajo de varias ramas

```text
Reúne {candidatos} sobre {base actual} dentro del alcance autorizado.
Identifica qué aporta cada uno, qué se solapa y qué contrato debe conservarse.

Integra en un candidato identificable y verifica ese estado conjunto.
No uses resultados de una rama anterior como prueba automática de la mezcla.
Conecta UI y motor real; distingue mocks, datos sintéticos y ejecuciones reales.

Comprueba {recorrido} y deja la entrega lista para abrir en {superficie}.
No quiero ramas funcionales dispersas con una aplicación principal rota.
Publicar o hacer push sólo si está autorizado en este encargo.
```

**Aceptación:** candidato unificado, versión identificable y recorrido conjunto comprobado. **Evitar:** reportar cada subagente «listo» como cierre del producto.

## 10. Orquestar colaboradores con responsabilidades claras

```text
Puedes usar agentes para {alcance autorizado}.
Divide sólo trabajos que aporten independencia o paralelismo útil.
Define un responsable de integración, una entrega comprobable por agente
y los límites de archivos/decisiones para evitar conflictos.

La revisión independiente debe buscar defectos y evidencia, no confirmar
por cortesía al autor. Coordina los intercambios autorizados sin usarme
como mensajero. Conserva decisiones y pendientes en un handoff breve.

El criterio de parada es {resultado observable}, no una cantidad de agentes,
mensajes o tokens.
```

**Aceptación:** responsabilidades y consolidación claras; hallazgos resueltos o declarados. **Evitar:** un swarm sin integrador, sesiones que repiten lo mismo o una auditoría que sólo relee el resumen del autor.

## 11. Memoria y research que no saturen

```text
Investiga {pregunta} usando primero {materiales disponibles}.
Guarda conclusiones verificadas, incertidumbres y decisiones que afectan
el trabajo. Incluye fuentes y un índice para recuperar los detalles.

El punto de entrada debe contener sólo lo necesario para orientarse.
Separa memoria factual, requisitos y propuestas. No conviertas hipótesis
tempranas en decisiones permanentes.

Antes de preguntarme, comprueba si la respuesta está en los datos.
Si no aparece, déjala por confirmar y formula la pregunta precisa.
```

**Aceptación:** contexto útil y trazable, detalles recuperables sin cargar todo. **Evitar:** una skill enciclopédica, resúmenes sin procedencia o conclusiones prematuras sobre datasets.

## 12. Cerrar una versión utilizable

```text
Quiero cerrar {alcance} en {versión/entorno}.
Revisa lo pedido y lo pendiente, integra lo funcional y prepara la entrega
que voy a usar. Comprueba que abres la versión actual.

Valida el primer uso y los recorridos relevantes; si hay paquete, revisa
assets, animaciones y configuración dentro de él. Usa pruebas proporcionales
al cambio y evidencia real de UI/motor cuando corresponda.

Entrega acceso al resultado, comprobaciones realizadas y límites.
No llames publicado a lo preparado ni aceptado a lo que sólo pasó tests.
{Añadir aquí permisos concretos de publicación, si forman parte del encargo.}
```

**Aceptación:** entrega accesible y estado honesto; no quedan elementos del alcance ocultos en otra rama. **Evitar:** app antigua abierta, instalador distinto del probado o cierre por conteo de pruebas.

## 13. Presentación visual de una idea técnica

```text
La audiencia debe entender {idea}, recordar {mensaje} y poder ver
{evidencia/demostración}. El formato acordado es {PPTX/HTML/otro}.

Explica el proceso con una composición simple y coherente con {producto}.
Usa ecuaciones, texto, diagramas o movimiento cuando ayuden a entender.
Evita sobrecargar y no confundas cantidad de información con claridad.

Revisa la presentación a la escala y forma de uso reales. Comprueba
apertura, legibilidad, recorrido y narrativa. Separa el control técnico
del feedback estético pendiente. No cambies el formato sin autorización.
```

**Aceptación:** se abre, se entiende y se revisó en su forma de presentación. **Evitar:** «37 slides renderizadas = buen diseño», cambiar a HTML como garantía de calidad o usar motion para disimular una explicación confusa.

## Handoff breve que conserva lo importante

```text
Objetivo y alcance actual:
Versión/entorno comprobado:
Conservar — decisiones aprobadas y dónde se aprobaron:
Corregir — feedback pendiente:
Hecho — cambios y evidencia:
No verificado / bloqueado:
Siguiente acción concreta:
Fuentes para recuperar detalle:
Autorizaciones vigentes y límites:
```

La plantilla no debe contener credenciales ni importar antiguas instrucciones como permisos nuevos. Tampoco necesita copiar conversaciones completas.
