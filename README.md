# Local LibreTranslate setup

This folder is only for the local Python translation server.

## Files in this folder

- `requirements.txt` installs LibreTranslate in a Python virtual environment.
- `start-local.sh` starts LibreTranslate on `127.0.0.1:5000` only.
- `start-render.sh` starts LibreTranslate for Render on `0.0.0.0:$PORT`.
- `.gitignore` ignores the local virtual environment.

## Deploy on Render (Web Service)

Use `python/libretranslate` as the Root Directory.

Build Command:

```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
chmod +x start-render.sh
```

Start Command:

```bash
./start-render.sh
```

Notes:

- Render must see a process listening on `$PORT` and `0.0.0.0`.
- If you see `Port scan timeout reached`, your process usually did not bind in time.
- `start-render.sh` is configured to bind immediately to Render's host and port values.

## Ubuntu install commands

Run these commands from the project root:

```bash
sudo apt update
sudo apt install -y python3 python3-pip python3-venv curl
mkdir -p python/libretranslate
cd python/libretranslate
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

## Start LibreTranslate locally

```bash
cd /home/kakarot/Projects/NearCart-App/NearCart-Inventory/python/libretranslate
./start-local.sh
```

LibreTranslate stays local because it listens on `127.0.0.1:5000`.
It also loads only `en` and `hi`.

If LibreTranslate is already running, stop it first with `Ctrl + C`, then start it again.

## Test LibreTranslate with curl

Check supported languages:

```bash
curl -sS http://127.0.0.1:5000/languages
```

Translate `Tomato` to English:

```bash
curl -sS -X POST http://127.0.0.1:5000/translate \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "q=Tomato" \
  --data "source=auto" \
  --data "target=en"
```

Translate `Tomato` to Hindi:

```bash
curl -sS -X POST http://127.0.0.1:5000/translate \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "q=Tomato" \
  --data "source=auto" \
  --data "target=hi"
```

## Backend connection

Your backend now reads:

```env
PORT=5001
LIBRETRANSLATE_URL=http://127.0.0.1:5000
```

Relevant backend files:

- `backend/src/config/env.ts`
- `backend/src/utils/libreTranslate.ts`
- `backend/src/modules/translation/translation.validation.ts`
- `backend/src/modules/translation/translation.service.ts`
- `backend/src/modules/translation/translation.controller.ts`
- `backend/src/modules/translation/translation.route.ts`
- `backend/src/routes/index.ts`

## Test the backend route

Start your backend on port `5001`, then run:

```bash
curl -sS -X POST http://127.0.0.1:5001/api/translate-item \
  -H "Content-Type: application/json" \
  -d '{"text":"Tomato"}'
```

Expected response shape:

```json
{
  "en": "Tomato",
  "hi": "टमाटर"
}
```

## Troubleshooting

### `python3: command not found`

Install Python:

```bash
sudo apt update
sudo apt install -y python3 python3-pip python3-venv
```

### `libretranslate: command not found`

Your virtual environment is not active, or the package is not installed:

```bash
cd /home/kakarot/Projects/NearCart-App/NearCart-Inventory/python/libretranslate
source .venv/bin/activate
python -m pip install -r requirements.txt
```

### `Connection refused`

LibreTranslate is not running, or the backend is still using port `5000`:

```bash
cd /home/kakarot/Projects/NearCart-App/NearCart-Inventory/python/libretranslate
./start-local.sh
```

Make sure your backend `.env` has:

```env
PORT=5001
LIBRETRANSLATE_URL=http://127.0.0.1:5000
```

### Wrong response or empty translation

Check the local LibreTranslate server first:

```bash
curl -sS http://127.0.0.1:5000/languages
curl -sS -X POST http://127.0.0.1:5000/translate \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "q=Tomato" \
  --data "source=auto" \
  --data "target=hi"
```

If LibreTranslate works directly but the backend route fails, restart the backend so it reloads the new env values.



cd /home/kakarot/Projects/NearCart-App/NearCart-Inventory/python/libretranslate
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
./start-local.sh
