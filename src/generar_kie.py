#!/usr/bin/env python3
"""
Genera las 3 variantes de la historia con Kie AI (nano banana 2).

Uso:
    export KIE_API_KEY="tu_api_key"
    python3 src/generar_kie.py                 # las 3 variantes
    python3 src/generar_kie.py v2-impacto      # solo una

Las imagenes se guardan en out/kie/<id>.png
No requiere dependencias externas (solo stdlib).
"""
import json
import os
import sys
import time
import urllib.error
import urllib.request

BASE = os.environ.get("KIE_BASE_URL", "https://api.kie.ai")
CREATE = f"{BASE}/api/v1/jobs/createTask"
RECORD = f"{BASE}/api/v1/jobs/recordInfo?taskId="

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PROMPTS = os.path.join(ROOT, "src", "prompts_kie.json")
OUTDIR = os.path.join(ROOT, "out", "kie")

POLL_EVERY = 6      # segundos entre consultas de estado
TIMEOUT = 600       # segundos maximos por variante


def api_key() -> str:
    key = os.environ.get("KIE_API_KEY", "").strip()
    if not key:
        sys.exit("Falta KIE_API_KEY. Ejecuta: export KIE_API_KEY='tu_api_key'")
    return key


def request(url: str, key: str, payload=None):
    data = json.dumps(payload).encode() if payload is not None else None
    req = urllib.request.Request(
        url,
        data=data,
        headers={
            "Authorization": f"Bearer {key}",
            "Content-Type": "application/json",
        },
        method="POST" if data else "GET",
    )
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            return json.loads(resp.read().decode())
    except urllib.error.HTTPError as exc:
        body = exc.read().decode(errors="replace")
        sys.exit(f"HTTP {exc.code} en {url}\n{body}")


def create_task(key: str, model: str, prompt: str, aspect: str) -> str:
    body = {
        "model": model,
        "input": {
            "prompt": prompt,
            "aspect_ratio": aspect,
            "output_format": "png",
        },
    }
    res = request(CREATE, key, body)
    task_id = (res.get("data") or {}).get("taskId") or res.get("taskId")
    if not task_id:
        sys.exit(f"No vino taskId en la respuesta:\n{json.dumps(res, indent=2)}")
    return task_id


def wait_for(key: str, task_id: str) -> list:
    deadline = time.time() + TIMEOUT
    while time.time() < deadline:
        res = request(RECORD + task_id, key)
        data = res.get("data") or {}
        state = str(data.get("state") or data.get("status") or "").lower()
        if state in ("success", "succeeded", "completed"):
            result = data.get("resultJson") or data.get("result") or {}
            if isinstance(result, str):
                result = json.loads(result)
            urls = result.get("resultUrls") or result.get("urls") or []
            if not urls and result.get("imageUrl"):
                urls = [result["imageUrl"]]
            return urls
        if state in ("fail", "failed", "error"):
            sys.exit(f"La tarea {task_id} fallo: {data.get('failMsg') or data}")
        print(f"    ... {state or 'en cola'}")
        time.sleep(POLL_EVERY)
    sys.exit(f"Timeout esperando la tarea {task_id}")


def download(url: str, dest: str) -> None:
    with urllib.request.urlopen(url, timeout=120) as resp, open(dest, "wb") as fh:
        fh.write(resp.read())


def main() -> None:
    key = api_key()
    cfg = json.load(open(PROMPTS, encoding="utf-8"))
    wanted = set(sys.argv[1:])
    variants = [v for v in cfg["variants"] if not wanted or v["id"] in wanted]
    if not variants:
        sys.exit(f"Sin coincidencias. Disponibles: {[v['id'] for v in cfg['variants']]}")

    os.makedirs(OUTDIR, exist_ok=True)
    for v in variants:
        print(f"[{v['id']}] {v['concept']}")
        model = v.get("model", cfg["model"])
        task_id = create_task(key, model, v["prompt"], cfg["aspect_ratio"])
        print(f"    modelo: {model}\n    taskId: {task_id}")
        urls = wait_for(key, task_id)
        if not urls:
            print("    sin imagenes en el resultado")
            continue
        for i, url in enumerate(urls):
            suffix = "" if i == 0 else f"-{i + 1}"
            dest = os.path.join(OUTDIR, f"{v['id']}{suffix}.png")
            download(url, dest)
            print(f"    guardada: {dest}")


if __name__ == "__main__":
    main()
