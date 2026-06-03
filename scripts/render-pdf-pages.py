#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import re
from pathlib import Path

import pypdfium2 as pdfium


VAULT_DIR = Path(os.environ.get("VAULT_DIR", Path.home() / "dev-vault")).expanduser()
DEFAULT_INBOX = VAULT_DIR / "classes" / "_inbox"
DEFAULT_OUT = VAULT_DIR / "classes" / "_pages"


def slugify(value: str) -> str:
    value = value.strip().lower()
    value = re.sub(r"[^a-z0-9]+", "-", value)
    value = re.sub(r"-{2,}", "-", value).strip("-")
    return value or "document"


def render_pdf(pdf_path: Path, out_root: Path, scale: float, overwrite: bool) -> int:
    doc = pdfium.PdfDocument(str(pdf_path))
    out_dir = out_root / slugify(pdf_path.stem)
    out_dir.mkdir(parents=True, exist_ok=True)

    rendered = 0
    for idx in range(len(doc)):
        page_no = idx + 1
        out_file = out_dir / f"page-{page_no:03d}.png"
        if out_file.exists() and not overwrite:
            continue

        page = doc[idx]
        bitmap = page.render(scale=scale)
        image = bitmap.to_pil()
        image.save(out_file, "PNG", optimize=True)
        rendered += 1

    return rendered


def main() -> None:
    parser = argparse.ArgumentParser(description="Render lecture PDFs into page images for visual inspection.")
    parser.add_argument("paths", nargs="*", type=Path, help="PDF files or folders. Defaults to classes/_inbox.")
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT, help="Output page image root.")
    parser.add_argument("--scale", type=float, default=2.0, help="Render scale. 2.0 is usually enough for slide text.")
    parser.add_argument("--overwrite", action="store_true", help="Overwrite existing rendered pages.")
    args = parser.parse_args()

    inputs = args.paths or [DEFAULT_INBOX]
    pdfs: list[Path] = []
    for item in inputs:
        item = item.expanduser()
        if item.is_dir():
            pdfs.extend(sorted(item.glob("*.pdf")))
        elif item.suffix.lower() == ".pdf":
            pdfs.append(item)

    args.out.mkdir(parents=True, exist_ok=True)

    total = 0
    for pdf in pdfs:
        count = render_pdf(pdf, args.out, args.scale, args.overwrite)
        total += count
        print(f"{pdf.name}: rendered {count} new page(s)")

    print(f"Done. Rendered {total} new page image(s) into {args.out}")


if __name__ == "__main__":
    main()
