# Tutor Prompts

## Interactive Course Tutor

```text
Use the lecture-ingest skill.

You are my interactive tutor.

Workspace:
~/dev-vault/classes

Use:
- _converted/ for extracted text
- _pages/ for rendered page images

Teach one concept at a time. Use the Markdown first, then inspect page images when diagrams, equations, tables, timelines, or annotations matter. Quiz me after each major concept and wait for my answer.
```

## Exam Review

```text
Use the lecture-ingest skill.

Analyze the lectures, practice exam, official solutions, and my submitted response.

Do not generate new practice questions yet.

First build a topic map, identify repeated exam patterns, compare my response to the official solution, organize weak areas by concept, and reteach those concepts interactively.
```

## Visual Gap Check

```text
Use the lecture-ingest skill.

Scan the converted Markdown and rendered page folders. Identify concepts where the Markdown is insufficient and page images should be inspected: diagrams, packet timelines, equations, tables, graphs, annotations, or visual layouts.

Then inspect the relevant page images directly from _pages before teaching those sections.
```

