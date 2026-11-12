# Introduction to Metagenomics (mag-2026)

Course material for a one-week introduction to metagenomics: lectures, local tutorials and their Galaxy
counterparts.

**Course site: <https://rvandamme.github.io/Metagenomics_course/>**

## How this repository works

The site is a [Quarto](https://quarto.org) website.

| Path | Content |
|---|---|
| `index.qmd` | home page: overview, schedule, AI policy, bibliography |
| `project.qmd` | the project, the presentations and the grades |
| `tutorials/` | the local tutorials, one page per practical |
| `slides.qmd`, `slides/` | the Slides page and the PDF files it links to |
| `setup.qmd` | how students install the tools |
| `pixi.toml`, `pixi.lock` | the tools of the local tutorials, with fixed versions for Linux and macOS |
| `scripts/check_setup.sh` | setup check, run with `pixi run check` |
| `galaxy.qmd` | which Galaxy (GTN) tutorial goes with which practical |
| `data/README.md` | every download of the tutorials, with size and md5 checksum |
| `figures/` | images used by the pages |
| `_quarto.yml` | site configuration (menu, theme) |
| `.github/workflows/publish.yml` | publishes the site on every push to `main` |

The code on the tutorial pages is **shown, not run**, when the site is built.

## Preview the site on your computer

Install [Pixi](https://pixi.sh), then run this in the repository folder:

```bash
pixi run -e site quarto preview
```

## Change a tool version

Edit `pixi.toml`, run `pixi lock`, test, and commit `pixi.toml` and `pixi.lock` together.

## Publish

Push to `main`. GitHub Actions renders the site and publishes it to the `gh-pages` branch.
One-time setup: in the repository settings, under Pages, choose "Deploy from a branch", branch `gh-pages`,
folder `/ (root)`.

## Licence

Text and slides: CC BY 4.0 (`LICENSE`). Code: MIT (`LICENSE-code`). Credits and data sources: `ATTRIBUTION.md`.
