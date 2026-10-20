# Prueba de ruteo

Comprueba que las reglas hacen que Claude Code cargue las skills correctas. Hay dos archivos de casos: `cases.json` (57 pedidos) y `cases_holdout2.json` (20 pedidos escritos después de las reglas).

```bash
bash tests/routing/setup.sh
python3 tests/routing/run.py rules r1.json
python3 tests/routing/score.py r1.json
ABS_CASES=cases_holdout2.json python3 tests/routing/run.py rules h2.json
ABS_CASES=cases_holdout2.json python3 tests/routing/score.py h2.json
```

- Cada pedido es una consulta real a `claude -p` y **consume tu límite de uso**. Córrelo en tandas chicas; `run.py` usa 3 workers y se detiene si ve el aviso de límite.
- Usa `--setting-sources project,local`: la prueba ve solo el pack y las skills que trae Claude Code. `setup.sh` copia los `skillOverrides` del pack (modo solo nombre) a la configuración del proyecto.
- Un pedido es **exacto** si carga todas las skills requeridas y ninguna fuera de las aceptables. Los casos con `req` vacío comprueban que no se cargue nada.
