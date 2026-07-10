# AlexandrIA

**Your private library of everything — every answer cited.**

AlexandrIA is a small, self-hostable app that turns a folder of your own documents
(PDFs, manuals, contracts, recipes, rulebooks…) into an AI assistant that answers
**only** from those documents and **cites the source** for every claim. It runs
100% locally against any OpenAI-compatible LLM — nothing leaves your machine (currently configured for qwen2.5-14b-instruct-1m).

AlexandrIA started as a problem I solved at work: giving a team reliable, cited answers over our own technical documentation. 
This repository is a public, independent reimplementation of that idea — my own code, written from scratch on my own time, using openly-licensed sample documents (the Wikibooks Cookbook recipes, CC BY-SA). 
No proprietary code or data is included. That's why the history starts from a single initial commit: it's the first release of this public version, not the internal development history.

- 🔒 **Private** — your files and the model stay on your computer.
- 📌 **Grounded & cited** — every factual claim links back to the source; if the
  answer isn't in your documents, it says so instead of inventing one.
- 🗂️ **Bring your own docs** — drop PDFs into `raw/`, ingest them into a Markdown
  wiki, and browse or chat over them.

## How it works

```
raw/     Your source documents (immutable).
wiki/    Generated Markdown knowledge base.
  index.md   Table of contents, mirrors the raw/ folder tree.
app/     FastAPI backend (serves the UI + chat, builds grounded context).
static/  Single-page front-end (sidebar browser + wiki viewer + chat).
```

The backend loads the relevant wiki sections for each question, sends them to the
LLM as strict context, and streams back an answer with inline `(wiki: …)` citations.
Retrieval is plain keyword scoring — no vector database required.

## Quickstart

1. Install [LM Studio](https://lmstudio.ai) (or any OpenAI-compatible server) and
   start a local model. The default expects `http://localhost:1234/v1`.
2. Run it:
   ```bash
   python -m venv venv && source venv/bin/activate   # Windows: venv\Scripts\activate
   pip install -r requirements.txt
   python -m uvicorn app.main:app --host 0.0.0.0 --port 8000
   ```
   (On Windows you can just double-click `launcher.bat`.)
3. Open http://localhost:8000

The browsing/search UI works with no model running; the chat needs the LLM.

## Configuration

The LLM endpoint is read from environment variables (defaults target LM Studio):

| Variable | Default | Notes |
|---|---|---|
| `LLM_BASE_URL` | `http://localhost:1234/v1` | Any OpenAI-compatible endpoint |
| `LLM_API_KEY` | `lm-studio` | Set your key here; **never commit real keys** |
| `LLM_MODEL_NAME` | `qwen2.5-14b-instruct-1m` | Model id served by your endpoint |

For a cloud model (e.g. Gemini via its OpenAI-compatible API), set these three
variables — do not hard-code secrets in the source.

## Adding your own documents

Drop source PDFs into `raw/` (grouped in subfolders however you like), then create
one Markdown page per topic under `wiki/` and add a row to `wiki/index.md` under a
`## Category / Sub / File.pdf` heading using the form `| [[page-slug]] | description |`.
The sidebar mirrors the `raw/` tree automatically.

## Sample content & licensing

- **Code**: MIT (see `LICENSE`).
- **Sample recipes** in `raw/Cooking/` and `wiki/*.md` come from the
  [Wikibooks Cookbook](https://en.wikibooks.org/wiki/Cookbook) and are licensed
  under **CC BY-SA 3.0**; the banana-cake recipe originates from Foodista (CC BY).
  They are included only as a working demo. Do not ingest copyrighted documents
  you don't have the right to redistribute.

## Disclaimer

Answers are only as good as the documents you provide and the model you run.
Always verify critical information against the original source.
