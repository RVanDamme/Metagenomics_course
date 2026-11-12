# Introduction to Metagenomics (mag-2026)

Course material for a one-week introduction to metagenomics: lectures, local tutorials and their Galaxy
counterparts.

**Course site: <https://rvandamme.github.io/Metagenomics_course/>**

## How this repository works

The site is a [Quarto](https://quarto.org) website.

| Path | Content |
|---|---|
| `index.qmd` | home page |
| `tutorials/` | the local tutorials, one page per practical |
| `slides.qmd`, `slides/` | the Slides page and the PDF files it links to |
| `figures/` | images used by the pages |
| `_quarto.yml` | site configuration (menu, theme) |
| `.github/workflows/publish.yml` | publishes the site on every push to `main` |

The code on the tutorial pages is **shown, not run**, when the site is built.

## Preview the site on your computer

Install [Quarto](https://quarto.org/docs/get-started/), then run this in the repository folder:

```bash
quarto preview
```

## Publish

Push to `main`. GitHub Actions renders the site and publishes it to the `gh-pages` branch.
One-time setup: in the repository settings, under Pages, choose "Deploy from a branch", branch `gh-pages`,
folder `/ (root)`.
