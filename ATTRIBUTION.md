---
title: "Licence and credits"
---

## Licence

- **Text and slides:** [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).
  The full text is in the file `LICENSE`.
- **Code** (commands, scripts, configuration files): MIT licence. The full text is in the file `LICENSE-code`.

You may reuse and adapt the material if you give credit:
"Introduction to Metagenomics, Renaud Van Damme and contributors, <https://github.com/RVanDamme/Metagenomics_course>, CC BY 4.0".

**Exception:** the PDF slides made before 2026 (in `slides/`) contain images from other sources. They are not
covered by the CC BY 4.0 licence. They will be replaced by rebuilt slides.

## Credits

This course is taught and maintained by Renaud Van Damme.

- **Tutorials.** The three local tutorials are shared teaching material, co-developed with **Hadrien Gourlé**.
  They started from his tutorials (<https://github.com/HadrienG/tutorials>, CC BY 4.0):
  *Whole Metagenome Sequencing*, *Metagenome assembly and binning* and *Metabarcoding*.
  The annotation and taxonomy parts of the assembly tutorial were written by Renaud Van Damme and Hadrien Gourlé.
- **Slides.** The introduction and shotgun lectures were developed with **Moritz Buck**.
  The ancient DNA lecture is based on the work of **Zoé Pochon**.
- **Galaxy tutorials.** The Galaxy route uses tutorials of the
  [Galaxy Training Network](https://training.galaxyproject.org) (CC BY 4.0). Each tutorial is linked with its
  title; its authors are listed on its page.

## Data

The course uses published data. If you reuse the data, cite the original studies.

| Practical | Data | Source |
|---|---|---|
| Day 1, read-based taxonomy | Pig gut metagenomes (subsampled) | Xiao et al. 2016, *Nature Microbiology*, [doi:10.1038/nmicrobiol.2016.161](https://doi.org/10.1038/nmicrobiol.2016.161) |
| Day 1, read-based taxonomy | Human gut metagenomes (subsampled) | Le Chatelier et al. 2013, *Nature*, [doi:10.1038/nature12506](https://doi.org/10.1038/nature12506) |
| Day 2, assembly and binning | Reads simulated with [InSilicoSeq](https://insilicoseq.readthedocs.io) from Tara Oceans genomes | Simulation by Hadrien Gourlé; genomes from the [Tara Oceans MAG collection](https://figshare.com/articles/TARA-NON-REDUNDANT-MAGs/4902923/1) |
| Day 2, amplicon | MiSeq SOP data (mouse gut, 16S V4) | Kozich et al. 2013, *Applied and Environmental Microbiology*, [doi:10.1128/AEM.01043-13](https://doi.org/10.1128/AEM.01043-13); distributed with the [mothur MiSeq SOP](https://mothur.org/wiki/miseq_sop/) |

Reference databases (Kraken 2, SILVA, CheckM, GTDB) are downloaded from their providers and keep their own
licences. Check the provider's terms before you redistribute a database.
