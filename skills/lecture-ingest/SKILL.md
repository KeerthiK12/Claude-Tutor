---
name: lecture-ingest
description: Use when the user wants to preserve, convert, study, summarize, or ask questions across lecture PDFs, slide decks, notes, or course documents without hitting Claude image/page upload limits. Converts PDFs/PPTX/DOCX to Markdown and stores course material in the dev-vault.
---

# Lecture Ingest

Use this skill for course PDFs, lecture slides, textbook chapters, academic notes, and study material.

## Goal

Avoid Claude's PDF image/page limits by converting documents locally to Markdown, then reading only the relevant Markdown sections.

## Canonical Folders

- Raw files inbox: `~/dev-vault/classes/_inbox`
- Converted Markdown: `~/dev-vault/classes/_converted`
- Rendered PDF page images: `~/dev-vault/classes/_pages`
- Course notes/indexes: `~/dev-vault/classes`

## Conversion

Use MarkItDown:

```bash
~/.local/bin/markitdown "input.pdf" > "output.md"
```

For batches:

```bash
~/dev-vault/classes/convert-inbox.sh
```

Render PDF pages for visual access:

```bash
~/dev-vault/classes/render-pages.sh
```

Rendered pages are stored as:

```text
~/dev-vault/classes/_pages/<pdf-name>/page-001.png
```

## Workflow

1. Ask for or identify the folder containing lecture PDFs.
2. Convert PDFs/PPTX/DOCX to Markdown in `_converted`.
3. Render PDFs to page images in `_pages` so diagrams, packet timelines, plots, and equations can be inspected automatically from local files.
4. Create or update a course index note in `~/dev-vault/classes/<course>.md`.
5. For each lecture, capture:
   - source file
   - lecture title/topic
   - key concepts
   - equations/definitions
   - examples
   - unclear OCR/conversion issues
6. Do not upload all PDFs to Claude chat.
7. When answering questions, read the relevant converted Markdown first.
8. If a concept depends on visuals, inspect the corresponding rendered page image from `_pages` automatically before asking the user for anything.
9. When tutoring, teach one concept at a time and quiz the user before continuing.

## Accuracy Rules

- If a PDF is scanned/image-only, MarkItDown may not extract accurate text. Flag it and recommend OCR.
- Preserve page references when available.
- Do not invent missing equations, figures, or diagrams.
- For diagrams-heavy slides, use rendered page images from `_pages` first.
- Ask the user for screenshots only if local rendered page images are missing or unreadable.
