# Claude PDF Tutor Kit

A minimal setup for learning from lecture PDFs, slide decks, exams, solutions, and course notes with Claude.

This repo does one thing:

```text
course PDFs/slides
→ Markdown text extraction
→ rendered page images for diagrams
→ Claude Code UI interactive tutoring
```

It is designed for classes where PDFs contain both text and important visuals: diagrams, equations, protocol timelines, plots, tables, circuits, annotations, or worked solutions.

## Why This Exists

Normal Claude chat can hit upload/page/image limits when you add many PDFs. It also cannot automatically read files from your computer unless you use a properly configured local connector.

This kit avoids that by preparing your files locally:

- MarkItDown extracts readable text into Markdown.
- A renderer converts each PDF page into a PNG image.
- Claude Code can read both local Markdown and local page images.
- You use Claude Code UI/Cowork as the interactive tutor.

## What Gets Installed

The setup script installs only the tutor workflow:

```text
~/.claude/skills/lecture-ingest/SKILL.md
~/dev-vault/classes/_inbox
~/dev-vault/classes/_converted
~/dev-vault/classes/_pages
~/dev-vault/classes/convert-inbox.sh
~/dev-vault/classes/render-pages.sh
~/dev-vault/classes/render-pdf-pages.py
~/.local/bin/markitdown
~/.local/venvs/markitdown
```

It does **not** install agents, coding workflows, startup planning tools, or global Claude memory.

## Requirements

- macOS or Linux
- Python 3.10+
- Claude Code
- Node/npm for installing Claude Code

Install Claude Code if needed:

```bash
npm install -g @anthropic-ai/claude-code
claude auth login
```

## Quickstart

Clone this repo:

```bash
git clone <YOUR_REPO_URL> claude-pdf-tutor-kit
cd claude-pdf-tutor-kit
```

Run setup:

```bash
./scripts/setup.sh
```

Restart your terminal, or run:

```bash
source ~/.zshrc 2>/dev/null || source ~/.bash_profile
```

Verify:

```bash
markitdown --version
ls ~/.claude/skills/lecture-ingest
ls ~/dev-vault/classes
```

## Prepare Course Files

Put raw files here:

```text
~/dev-vault/classes/_inbox
```

Supported by the default conversion workflow:

- PDF
- PPTX
- DOCX
- HTML

Convert files to Markdown:

```bash
~/dev-vault/classes/convert-inbox.sh
```

Render PDF pages to images:

```bash
~/dev-vault/classes/render-pages.sh
```

Outputs:

```text
~/dev-vault/classes/_converted   # extracted Markdown text
~/dev-vault/classes/_pages       # rendered page images
```

## Why Markdown Plus Page Images?

Markdown is good for:

- searchable lecture text
- definitions
- bullet points
- solution text
- fast context loading

Rendered page images are needed for:

- diagrams
- equations
- packet timelines
- protocol stacks
- graphs and plots
- tables
- circuit drawings
- handwritten annotations
- slide layouts where spatial relationships matter

MarkItDown alone is not enough for diagram-heavy lectures. Use both.

## Best Way To Learn

Use **Claude Code UI/Cowork** if available, with working directory:

```text
~/dev-vault/classes
```

Then paste:

```text
Use the lecture-ingest skill.

You are my interactive tutor.

Workspace:
~/dev-vault/classes

Use:
- _converted/ for extracted lecture and exam text
- _pages/ for rendered PDF page images
- _inbox/ only as raw source reference

Important behavior:
- Use Markdown as the main text backbone.
- When a concept depends on a diagram, timeline, graph, table, equation, annotation, or visual layout, automatically inspect the corresponding rendered page image in _pages.
- Do not ask me for screenshots unless the rendered page image is missing or unreadable.
- Teach interactively, one concept at a time.
- Start with the big picture, then definitions, intuition, mechanism, example, common exam trap, and a mini quiz.
- Wait for my answer after each quiz before continuing.
- If I get something wrong, diagnose the misunderstanding and reteach it.
- Track weak areas as we go.

First, inventory the available converted Markdown files and rendered page-image folders.
Then create a topic map and recommended study order.
Then begin teaching the first topic interactively.
```

## Exam Prep Prompt

If you added lectures, a practice exam, official solutions, and your own submission:

```text
Use the lecture-ingest skill.

I am preparing for an exam.

Use:
- _converted/ for extracted text
- _pages/ for rendered page images when visuals matter

Materials may include:
- lecture PDFs/slides
- practice exam with solutions
- official exam solutions
- my submitted response

Do not generate new practice questions yet.

First:
1. Build a topic map from the lectures.
2. Identify which topics appear repeatedly in the exams.
3. Compare my submitted response against official solutions if available.
4. Organize weak areas by concept, not just question number.
5. Teach the weak concepts from the ground up.
6. Quiz me after each major concept.
7. Use rendered page images automatically when diagrams, equations, tables, or annotations matter.
```

## Normal Claude Chat vs Claude Code

Normal Claude chat may not be able to access:

```text
~/dev-vault/classes/_converted
~/dev-vault/classes/_pages
```

unless you have configured a local filesystem connector. If it says it cannot access your local path, that is expected.

Best options:

1. Use Claude Code UI/Cowork for local file access and tutoring.
2. Use Claude Code terminal if UI is unavailable.
3. Upload selected Markdown files and selected page images manually into normal Claude chat.

## Repo Contents

```text
.
├── README.md
├── scripts/
│   ├── setup.sh
│   ├── convert-inbox.sh
│   ├── render-pages.sh
│   └── render-pdf-pages.py
├── skills/
│   └── lecture-ingest/SKILL.md
├── templates/
│   └── classes/README.md
└── docs/
    └── PROMPTS.md
```

## Safety And Privacy

Do not commit:

- lecture PDFs
- exams
- homework submissions
- answer keys
- personal course notes
- screenshots of private materials

This repo intentionally includes only scripts, prompts, and the tutor skill.

## Troubleshooting

### `/skills` does not show `lecture-ingest`

Run:

```bash
./scripts/setup.sh
```

Then restart Claude Code.

### `markitdown: command not found`

Restart Terminal or run:

```bash
source ~/.zshrc 2>/dev/null || source ~/.bash_profile
```

### Diagrams are missing from Markdown

That is normal. Run:

```bash
~/dev-vault/classes/render-pages.sh
```

Then ask Claude to inspect `_pages`.

### Claude says it cannot access `~/dev-vault`

Use Claude Code UI/Cowork or Claude Code terminal. Normal Claude chat cannot always access local files.

## Sources

- [Claude Code setup](https://docs.claude.com/en/docs/claude-code/setup)
- [Claude Code skills](https://docs.claude.com/en/docs/claude-code/skills)
- [Microsoft MarkItDown](https://github.com/microsoft/markitdown)

