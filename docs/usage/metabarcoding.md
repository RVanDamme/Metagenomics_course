# Metabarcoding

This tutorial is aimed at being a walkthrough of the DADA2 pipeline.
It uses the data of the now famous [MiSeq SOP](http://www.mothur.org/wiki/MiSeq_SOP) by the Mothur authors but analyses the data using DADA2.

DADA2 is a relatively new method to analyse amplicon data which uses exact variants instead of OTUs.    

The advantages of the DADA2 method is described in the [paper](http://dx.doi.org/10.1038/ismej.2017.119)

## Before Starting

There are two ways to follow this tutorial: you can copy and paste all the codes blocks below in R directly, or you can download this document in the Rmarkdown format and execute the cells.

* [Link to the document in Rmarkdown](data/16S.Rmd)

## Install and Load Packages

First install DADA2 and other necessary packages (line by line)

```r {r install_pkg}
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
# BiocManager::install(c("dada2","phyloseq","DECIPHER"))
# install.packages('ggplot2')
# install.packages('phangorn')
# BiocManager::install(c("GenomicRanges"))
# BiocManager::install(c("DelayedArray"))
```

Now load the packages and verify you have the correct DADA2 version

```r
library(dada2)
library(ggplot2)
library(phyloseq)
library(phangorn)
library(DECIPHER)
packageVersion('dada2')
```

## Download the Data

You will also need to download the data, as well as the SILVA database

!!! warning
    If you are following the tutorial on the website, the following block of commands has to be executed outside of R.
    If you run this tutorial with the R notebook, you can simply execute the cell block

```bash
wget http://www.mothur.org/w/images/d/d6/MiSeqSOPData.zip
unzip MiSeqSOPData.zip
rm -r __MACOSX/
cd MiSeq_SOP
wget https://zenodo.org/record/824551/files/silva_nr_v128_train_set.fa.gz
wget https://zenodo.org/record/824551/files/silva_species_assignment_v128.fa.gz
cd ..
```

Back in R, check that you have downloaded the data

```r
path <- 'MiSeq_SOP'
list.files(path)
```

## Filtering and Trimming

First we create two lists with the sorted name of the reads: one for the forward reads, one for the reverse reads

```r
raw_forward <- sort(list.files(path, pattern="_R1_001.fastq",
                               full.names=TRUE))

raw_reverse <- sort(list.files(path, pattern="_R2_001.fastq",
                               full.names=TRUE))

# we also need the sample names
sample_names <- sapply(strsplit(basename(raw_forward), "_"),
                       `[`,  # extracts the first element of a subset
                       1)
```

then we visualise the quality of our reads

```r
plotQualityProfile(raw_forward[1:2])
plotQualityProfile(raw_reverse[1:2])
```

!!! question
    What do you think of the read quality?

The forward reads are good quality (although dropping a bit at the end as usual) while the reverse are way worse.

Based on these profiles, we will truncate the forward reads at position 240 and the reverse reads at position 160 where the quality distribution crashes.


!!! note
    in this tutorial we perform the trimming using DADA2's own functions.
    If you wish to do it outside of DADA2, you can refer to the [Quality Control tutorial](qc.md)

---

Dada2 requires us to define the name of our output files

```r
# place filtered files in filtered/ subdirectory
filtered_path <- file.path(path, "filtered")

filtered_forward <- file.path(filtered_path,
                              paste0(sample_names, "_R1_trimmed.fastq.gz"))

filtered_reverse <- file.path(filtered_path,
                              paste0(sample_names, "_R2_trimmed.fastq.gz"))
```

We’ll use standard filtering parameters: `maxN=0` (DADA22 requires no Ns), `truncQ=2`, `rm.phix=TRUE` and `maxEE=2`.
The maxEE parameter sets the maximum number of “expected errors” allowed in a read, which [according to the USEARCH authors](http://www.drive5.com/usearch/manual/expected_errors.html) is a better filter than simply averaging quality scores.

```r
out <- filterAndTrim(raw_forward, filtered_forward, raw_reverse,
                     filtered_reverse, truncLen=c(240,160), maxN=0,
                     maxEE=c(2,2), truncQ=2, rm.phix=TRUE, compress=TRUE,
                     multithread=TRUE)
head(out)
```

## Learn the Error Rates

The DADA2 algorithm depends on a parametric error model and every amplicon dataset has a slightly different error rate.
The `learnErrors` of Dada2 learns the error model from the data and will help DADA2 to fits its method to your data

```r
errors_forward <- learnErrors(filtered_forward, multithread=TRUE)
errors_reverse <- learnErrors(filtered_reverse, multithread=TRUE)
```

then we visualise the estimated error rates

```r
plotErrors(errors_forward, nominalQ=TRUE) +
    theme_minimal()
```

!!! question
    Do you think the error model fits your data correctly?

## Dereplication

From the Dada2 documentation:

> **Dereplication** combines all identical sequencing reads into into “unique sequences” with a corresponding “abundance”: the number of reads with that unique sequence.
> **Dereplication** substantially reduces computation time by eliminating redundant comparisons.

```r
derep_forward <- derepFastq(filtered_forward, verbose=TRUE)
derep_reverse <- derepFastq(filtered_reverse, verbose=TRUE)
# name the derep-class objects by the sample names
names(derep_forward) <- sample_names
names(derep_reverse) <- sample_names
```

## Sample inference

We are now ready to apply the core sequence-variant inference algorithm to the dereplicated data.

```r
dada_forward <- dada(derep_forward, err=errors_forward, multithread=TRUE)
dada_reverse <- dada(derep_reverse, err=errors_reverse, multithread=TRUE)

# inspect the dada-class object
dada_forward[[1]]
```

The DADA2 algorithm inferred 128 real sequence variants from the 1979 unique sequences in the first sample.

## Merge Paired-end Reads

Now that the reads are trimmed, dereplicated and error-corrected we can merge them together

```r
merged_reads <- mergePairs(dada_forward, derep_forward, dada_reverse,
                           derep_reverse, verbose=TRUE)

# inspect the merger data.frame from the first sample
head(merged_reads[[1]])
```

## Construct Sequence Table

We can now construct a sequence table of our mouse samples, a higher-resolution version of the OTU table produced by traditional methods.

```r
seq_table <- makeSequenceTable(merged_reads)
dim(seq_table)

# inspect distribution of sequence lengths
table(nchar(getSequences(seq_table)))
```

## Remove Chimeras

The `dada` method used earlier removes substitutions and indel errors but chimeras remain.
We remove the chimeras with

```r
seq_table_nochim <- removeBimeraDenovo(seq_table, method='consensus',
                                       multithread=TRUE, verbose=TRUE)
dim(seq_table_nochim)

# which percentage of our reads did we keep?
sum(seq_table_nochim) / sum(seq_table)
```

As a final check of our progress, we’ll look at the number of reads that made it through each step in the pipeline

```r
get_n <- function(x) sum(getUniques(x))

track <- cbind(out, sapply(dada_forward, get_n), sapply(merged_reads, get_n),
               rowSums(seq_table), rowSums(seq_table_nochim))

colnames(track) <- c('input', 'filtered', 'denoised', 'merged', 'tabled',
                     'nonchim')
rownames(track) <- sample_names
head(track)
```

We kept the majority of our reads!

## Assign Taxonomy

Now we assign taxonomy to our sequences using the SILVA database

```r
taxa <- assignTaxonomy(seq_table_nochim,
                       'MiSeq_SOP/silva_nr_v128_train_set.fa.gz',
                       multithread=TRUE)
taxa <- addSpecies(taxa, 'MiSeq_SOP/silva_species_assignment_v128.fa.gz')
```

for inspecting the classification

```r
taxa_print <- taxa  # removing sequence rownames for display only
rownames(taxa_print) <- NULL
head(taxa_print)
```

## Phylogenetic Tree

DADA2 is reference-free so we have to build the tree ourselves

We first align our sequences

```r
sequences <- getSequences(seq_table)
names(sequences) <- sequences  # this propagates to the tip labels of the tree
alignment <- AlignSeqs(DNAStringSet(sequences), anchor=NA)
```

Then we build a neighbour-joining tree then fit a maximum likelihood tree using the neighbour-joining tree as a starting point

```r
phang_align <- phyDat(as(alignment, 'matrix'), type='DNA')
dm <- dist.ml(phang_align)
treeNJ <- NJ(dm)  # note, tip order != sequence order
fit = pml(treeNJ, data=phang_align)

## negative edges length changed to 0!

fitGTR <- update(fit, k=4, inv=0.2)
fitGTR <- optim.pml(fitGTR, model='GTR', optInv=TRUE, optGamma=TRUE,
                    rearrangement = 'stochastic',
                    control = pml.control(trace = 0))
detach('package:phangorn', unload=TRUE)
```

## Phyloseq

First load the metadata

```r
sample_data <- read.table(
    'https://hadrieng.github.io/tutorials/data/16S_metadata.txt',
    header=TRUE, row.names="sample_name")
```

We can now construct a phyloseq object from our output and newly created metadata

```r
physeq <- phyloseq(otu_table(seq_table_nochim, taxa_are_rows=FALSE),
                   sample_data(sample_data),
                   tax_table(taxa),
                   phy_tree(fitGTR$tree))
# remove mock sample
physeq <- prune_samples(sample_names(physeq) != 'Mock', physeq)
physeq
```

Let's look at the alpha diversity of our samples

```r
plot_richness(physeq, x='day', measures=c('Shannon', 'Fisher'), color='when') +
    theme_minimal()
```

No obvious differences. Let's look at ordination methods (beta diversity)

We can perform an MDS with euclidean distance (mathematically equivalent to a PCA)

```r
ord <- ordinate(physeq, 'MDS', 'euclidean')
plot_ordination(physeq, ord, type='samples', color='when',
                title='PCA of the samples from the MiSeq SOP') +
    theme_minimal()
```

now with the Bray-Curtis distance

```r
ord <- ordinate(physeq, 'NMDS', 'bray')
plot_ordination(physeq, ord, type='samples', color='when',
                title='PCA of the samples from the MiSeq SOP') +
    theme_minimal()
```

There we can see a clear difference between our samples.

Let us take a look a the distribution of the most abundant families

```r
top20 <- names(sort(taxa_sums(physeq), decreasing=TRUE))[1:20]
physeq_top20 <- transform_sample_counts(physeq, function(OTU) OTU/sum(OTU))
physeq_top20 <- prune_taxa(top20, physeq_top20)
plot_bar(physeq_top20, x='day', fill='Family') +
    facet_wrap(~when, scales='free_x') +
    theme_minimal()
```

We can place them in a tree

```r
bacteroidetes <- subset_taxa(physeq, Phylum %in% c('Bacteroidetes'))
plot_tree(bacteroidetes, ladderize='left', size='abundance',
          color='when', label.tips='Family')
```
