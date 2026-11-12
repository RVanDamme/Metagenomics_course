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

## Day 2: amplicon sequencing (DADA2)

| File | Size | Download | md5 |
|---|---|---|---|
| `miseqsopdata.zip` (MiSeq SOP, 20 samples) | 37 MB | <https://mothur.s3.us-east-2.amazonaws.com/wiki/miseqsopdata.zip> | `98144f5057628139271d94612bb27d96` |
| `silva_nr_v128_train_set.fa.gz` | 54 MB | [Zenodo 824551](https://zenodo.org/record/824551) | `26b23e13ed310174ae5563e8f7258ecc` |
| `silva_species_assignment_v128.fa.gz` | 34 MB | [Zenodo 824551](https://zenodo.org/record/824551) | `f67d7d9443312ca38a9fbf61fc744ae4` |

## Disk space

| What | Size |
|---|---|
| Tools (all Pixi environments) | about 12 GB |
| Databases | about 13 GB |
| Course data | about 1 GB |
| Results of the tutorials | about 2 GB |
| **Total** | **about 28 GB** (up to 34 GB for a moment while unpacking) |

Checksums were computed on 12 November 2026.
