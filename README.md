# Historias de inversión — 3 variantes (Instagram / Facebook Stories)

Tres versiones de la misma historia en **1080 × 1920 px**, con distinto copy, paleta y estilo.

| Variante | Estilo | Paleta | Ángulo del copy |
|---|---|---|---|
| `v1-confianza` | Corporativo, sobrio | Azul petróleo + dorado | Directo e institucional: *"Buscamos inversionistas"* |
| `v2-impacto` | Brutalista, alto contraste | Negro + verde lima | Gancho emocional: *"Tu dinero no debería dormir"* |
| `v3-premium` | Editorial, elegante | Crema + esmeralda + oro | Aspiracional: *"Haz que tu dinero trabaje por ti"* |

Las tres incluyen la información pedida: oportunidad de inversión, se buscan
inversionistas, desde $20,000 MXN, 30% de retorno anual y DM para detalles.

## Archivos

```
out/                    PNG finales listos para publicar (1080x1920)
src/*.html              Fuente editable de cada variante
src/prompts_kie.json    Prompts para Kie AI (nano banana 2)
src/generar_kie.py      Script que genera las variantes con Kie AI
assets/fonts/           Tipografías usadas (Archivo Black, Bebas Neue, Inter, Playfair, Manrope)
renderizar.sh           Re-renderiza los PNG desde los HTML
```

## Editar el texto o los colores

Los PNG de `out/` salen de los HTML de `src/`. Cambia el texto o los colores en
el HTML y vuelve a renderizar:

```bash
./renderizar.sh
```

Requiere Chromium. Si el binario está en otra ruta:
`CHROME=/ruta/a/chrome ./renderizar.sh`

## Generarlas con Kie AI (nano banana 2)

```bash
export KIE_API_KEY="tu_api_key"
python3 src/generar_kie.py              # las 3 variantes
python3 src/generar_kie.py v2-impacto   # solo una
```

Las imágenes quedan en `out/kie/`. El script no tiene dependencias externas.

Notas:

- La API key **no** está guardada en el repo; se lee de la variable de entorno
  `KIE_API_KEY`.
- Modelo y proporción se configuran en `src/prompts_kie.json`
  (`model`: `google/nano-banana-2`, `aspect_ratio`: `9:16`).
- El script usa `POST /api/v1/jobs/createTask` y consulta el estado en
  `GET /api/v1/jobs/recordInfo?taskId=...`. Si Kie AI cambia el nombre del
  modelo o la forma de la respuesta, se ajusta en `src/generar_kie.py`
  (funciones `create_task` y `wait_for`).

## Zonas seguras de Stories

El contenido está dentro del área central: se dejan ~250 px libres arriba (foto
de perfil y nombre) y ~250 px abajo (barra de respuesta y stickers).
