# Chowdown

A simple, plaintext recipe database for hackers.

## Local Development

This site runs on Jekyll 4.4.1. Ruby is **not** required locally — use Docker.

```
docker compose up
```

The site will be available at `http://localhost:4000`. The browser reloads automatically when you save a file (livereload on port 35729).

To stop: `Ctrl-C`, then `docker compose down`.

## Deployment

The site deploys automatically to GitHub Pages via GitHub Actions whenever you push to `master`. No manual build step needed.

> **Note:** GitHub Pages must be configured to use **GitHub Actions** as the source, not "Deploy from a branch". This is set under Settings → Pages → Source in the repo.

## Adding a Recipe

Recipes live in `/_recipes` as Markdown files with YAML front matter.

```yaml
---
layout: recipe
title: My Recipe
source: https://example.com/original-recipe   # optional
ingredients:
  - 1 cup flour
  - 2 eggs
directions:
  - Mix the flour and eggs.
  - Cook for 20 minutes.
tags: Baking
---

Optional intro text goes here in the body.
```

If `source` is set, a linked "Adapted from:" attribution appears at the bottom of the page and in the print footer.

## Adding a Component Recipe

A component recipe is built from smaller sub-recipes stored in `/_components`. To create one:

1. Add each sub-recipe as its own file in `/_components`
2. Create a new recipe in `/_recipes` with a `components` list in the front matter instead of `ingredients`

See `/_recipes/red-berry-tart.md` for an example.

## Dependency Updates

Gems are managed via Bundler. To update dependencies, run through Docker:

```
docker run --rm -v "$PWD:/site" -w /site ruby:3.2-alpine \
  sh -c "apk add --no-cache build-base libffi-dev > /dev/null && \
         gem install bundler --no-document > /dev/null && \
         bundle update"
```

Commit the updated `Gemfile.lock` afterward.
