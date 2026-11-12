---
title: "Data and databases"
---

Every file that the local tutorials download is listed here, with its size and its **md5 checksum**.
No large file is stored in this repository.

::: {.callout-tip title="In class"}
The teacher has a copy of all these files on a drive. Copy them from the drive instead of downloading them:
it is much faster, and it does not depend on the internet connection of the room.
:::

## How to check a file

A checksum is a fingerprint of a file. If your file gives the same checksum as the one in the table, the download
is complete and correct.

```bash
md5sum subset_wms.tar.gz        # Linux and WSL
md5 subset_wms.tar.gz           # macOS
```

In R: `tools::md5sum('miseqsopdata.zip')`.

## Day 1: read-based taxonomy

| File | Size | Download | md5 |
|---|---|---|---|
| `subset_wms.tar.gz` (6 gut samples, 100,000 read pairs each) | 111 MB (363 MB unpacked) | <https://osf.io/h9x6e/download> | `1aca45157f01be9500bcfcd0c3c66e9b` |
| `k2_standard_08_GB_20261022.tar.gz` (Kraken 2 Standard-8 database, 22 Oct 2026) | 5.9 GB (8.7 GB unpacked) | <https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08_GB_20261022.tar.gz> | `7447d230ea402d0b523c14d217b5c20b` |

The Kraken 2 database comes from the [Kraken 2 index page](https://benlangmead.github.io/aws-indexes/k2).

::: {.callout-note title="Short on disk space?"}
Downloading the Kraken 2 archive and then unpacking it needs about 15 GB for a moment. To use only 8.7 GB, unpack
while downloading:

```bash
mkdir -p ~/mag2026/databases/k2_standard_08gb
cd ~/mag2026/databases/k2_standard_08gb
curl -L https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08_GB_20261022.tar.gz | tar xzf -
md5sum hash.k2d      # must be 68e052782ee8f31df0699747402e5c82
```
:::

## Day 2: assembly and binning

| File | Size | Download | md5 |
|---|---|---|---|
| `tara_reads_R1.fastq.gz` | 99 MB | <https://osf.io/th9z6/download> | `e535bcf613be85d4720cfe4dbd5b99a4` |
| `tara_reads_R2.fastq.gz` | 101 MB | <https://osf.io/k6vme/download> | `24a1b4e13963666e854671346d653b35` |
| `checkm_data_2015_01_16.tar.gz` (CheckM 1 reference data) | 289 MB (1.4 GB unpacked) | <https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_2015_01_16.tar.gz> (mirror: [Zenodo 7401545](https://zenodo.org/records/7401545)) | `631012fa598c43fdeb88c619ad282c4d` |
| `checkm2_database.tar.gz` (CheckM2 database) | 1.7 GB (2.9 GB unpacked) | [Zenodo 14897628](https://zenodo.org/records/14897628) | `07c10655620843b517d0df0c160d911f` |

### The sourmash database for the taxonomy of the bins {#sourmash-db}

| File | Size | Source | md5 |
|---|---|---|---|
| `gtdb-reps-rs226-k31.s10k.zip` | 447 MB | made for this course (see below); from the teacher | `89f132ff5af712356e4cefdcc1a6cf68` |
| `gtdb-rs226.lineages.csv` | 103 MB | <https://farm.cse.ucdavis.edu/~ctbrown/sourmash-db.new/gtdb-rs226/gtdb-rs226.lineages.csv> | `519293f254dfa763c6f30473d1e3e952` |

**What the file is.** `gtdb-reps-rs226-k31.s10k.zip` contains one sourmash sketch (k = 31) for each of the 143,384
species-representative genomes of [GTDB](https://gtdb.ecogenomic.org) release 226. It is a reduced copy of the
official sourmash database `gtdb-reps-rs226-k31.dna.zip` (3.9 GB), listed on the
[sourmash databases page](https://sourmash.readthedocs.io/en/latest/databases.html).

**Why it is reduced.** The official file keeps 1 k-mer in 1,000 of each genome (`scaled=1000`). Searching it takes
6 minutes per bin, or 6 GB of memory with the fast search. The course file keeps 1 k-mer in 10,000
(`scaled=10000`): the search takes 1 minute per bin and less than 1 GB of memory. On the course data it gives the
same species for every bin as the official file.

**How to use it.** Sketch your genomes with the same settings, `-p k=31,scaled=10000`, then run `sourmash gather`
and `sourmash tax genome` as in the [assembly and binning tutorial](../tutorials/d2-assembly-binning.qmd).

**How it was made.** Anyone can rebuild it from the official file (8 minutes, 4.5 GB of memory):

```bash
curl -O https://farm.cse.ucdavis.edu/~ctbrown/sourmash-db.new/gtdb-rs226/gtdb-reps-rs226-k31.dna.zip
sourmash sig downsample --scaled 10000 gtdb-reps-rs226-k31.dna.zip -o gtdb-reps-rs226-k31.s10k.zip
```

**Limits.** A sketch this small is made for whole genomes and bins of 1 Mb or more. Do not use it for short
contigs or for reads.

## Day 2: amplicon sequencing (DADA2)

| File | Size | Download | md5 |
|---|---|---|---|
| `miseqsopdata.zip` (MiSeq SOP, 20 samples) | 37 MB | <https://mothur.s3.us-east-2.amazonaws.com/wiki/miseqsopdata.zip> | `98144f5057628139271d94612bb27d96` |
| `silva_nr99_v138.2_toGenus_trainset.fa.gz` (SILVA 138.2 for DADA2) | 140 MB | [Zenodo 14169026](https://zenodo.org/records/14169026) | `1764e2a36b4500ccb1c7d5261948a414` |
| `silva_v138.2_assignSpecies.fa.gz` | 70 MB | [Zenodo 14169026](https://zenodo.org/records/14169026) | `62fd939bd1aa9832d2089847f9f0b87d` |

## Disk space

| What | Size |
|---|---|
| Tools (all Pixi environments) | about 12 GB |
| Databases | about 14 GB |
| Course data | about 1 GB |
| Results of the tutorials | about 2 GB |
| **Total** | **about 28 GB** (up to 34 GB for a moment while unpacking) |

Checksums were computed on 12 November 2026.
