# Metagenome assembly and binning

Before anything RUN THIS:

```bash
conda create -n Meta_assembly -c bioconda fastqc sickle-trim megahit bowtie2 samtools metabat2=2.15 checkm-genome prokka
conda create -n sour -c bioconda sourmash=4.5.0
```

In this tutorial you'll learn how to inspect assemble metagenomic data and retrieve draft genomes from assembled metagenomes

We'll use a mock community of 20 bacteria sequenced using the Illumina HiSeq.
In reality the data were simulated using [InSilicoSeq](http://insilicoseq.readthedocs.io).

The 20 bacteria in the dataset were selected from the [Tara Ocean study](http://ocean-microbiome.embl.de/companion.html) that recovered 957 distinct Metagenome-assembled-genomes (or MAGs) that were previsouly unknown! (full list on [figshare](https://figshare.com/articles/TARA-NON-REDUNDANT-MAGs/4902923/1) )

## Getting the Data

```bash
mkdir -p ~/data
cd ~/data
curl -O -J -L https://osf.io/th9z6/download
curl -O -J -L https://osf.io/k6vme/download
chmod -w tara_reads_R*
```

## Quality Control

we'll use FastQC to check the quality of our data, as well as sickle for trimming the bad quality part of the reads.
If you need a refresher on how and why to check the quality of sequence data, please check the [Quality Control and Trimming](qc) tutorial

```bash
mkdir -p ~/results
cd ~/results
ln -s ~/data/tara_reads_* .
fastqc tara_reads_*.fastq.gz
```

!!! question
    What is the average read length? The average quality?

!!! question
    Compared to single genome sequencing, what graphs differ?


Now we'll trim the reads using sickle

```
sickle pe -f tara_reads_R1.fastq.gz -r tara_reads_R2.fastq.gz -t sanger \
    -o tara_trimmed_R1.fastq -p tara_trimmed_R2.fastq -s /dev/null
```

!!! question
    How many reads were trimmed?

## Assembly

Megahit will be used for the assembly.

```
megahit -1 tara_trimmed_R1.fastq -2 tara_trimmed_R2.fastq -o tara_assembly
```

the resulting assembly can be found under `tara_assembly/final.contigs.fa`.

!!! question
    How many contigs does this assembly contain?

## Binning

First we need to map the reads back against the assembly to get coverage information

```bash
ln -s tara_assembly/final.contigs.fa .
bowtie2-build final.contigs.fa final.contigs
bowtie2 -x final.contigs -1 tara_reads_R1.fastq.gz -2 tara_reads_R2.fastq.gz | \
    samtools view -bS -o tara_to_sort.bam
samtools sort tara_to_sort.bam -o tara.bam
samtools index tara.bam
```

then we run metabat

```bash
runMetaBat.sh -m 1500 final.contigs.fa tara.bam
mv final.contigs.fa.metabat-bins1500 metabat
```

!!! question
    How many bins did we obtain?

## Checking the quality of the bins

The first time you run `checkm` you have to create the database

```bash
mkdir   db/
wget --no-check-certificate https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_2015_01_16.tar.gz
mv  checkm_data_2015_01_16.tar.gz db/
cd db/
tar -xzvf checkm_data_2015_01_16.tar.gz
cd ..
checkm data setRoot db/
```

```bash
checkm lineage_wf -x fa metabat checkm/
checkm qa  checkm/lineage.ms checkm > checkm.txt
```

!!! question
    Which bins should we keep for downstream analysis?


## Functional annotation

Now we should have a collection of MAGs that we can further analyze. The first step is to predict genes as right now we only have raw genomic sequences. We will use one of my all-time-favorites : prokka.

This tool does gene prediction as well as some decent and useful annotations, and is actually quite easy to run!

Prokka produces a number of output files that all kinds of represent similar things. Mostly variants of FASTA-files, one with the genome again, one with the predicted proteins, one with the genes of the predicted proteins. Also, it renames all the sequences with nicer IDs! Additionally, a very useful file generated is a GFF-file, which gives more information about the annotations than just the names you can see in the FASTA-files.

The annotations of prokka are good but not very complete for environmental bacteria. Let’s run an other tool I like a lot, eggNOGmapper. This is a bit heavier in computation.

    Install eggNOG-mapper run it on at least one MAG (don’t be greedy, it is not fast!) OPTIONAL : undestand the output of it …

## Taxonomic annotation

We now know more about the genes your MAG contains, however we do not really know who we have?! checkm might have given us an indication but it is only approximative.

Taxonomic classification for full genomes is not always easy for MAGs, often the 16S gene is missing as it assembles badly, and which other genes to use to for taxonomy is not always evident. Typically marker genes, min-hashes or k-mer databases are used as reference. It is often problematic for environmental data as the databases are not biased into our direction! We will use a min-hash database I compiled specifically for this (based on other tools and the full-datasets) using a tool called [sourmash](https://sourmash.readthedocs.io/en/latest/)

    Install sourmash in your computer! 
    
    ```bash
    conda deactivate
    conda activate sour
    sourmash compute -k 31 --scaled 10000 metabat/bin.* 
    ```
    
    to compute signatures Use the lca clasify function of sourmash with the database you can find here 
    
    ```bash
    wget https://osf.io/download/p9ezm -O gtdb-rs207.genomic-reps.dna.k31.lca.json.gz
    
    sourmash lca classify --query bin.1.fa.sig --db gtdb-rs207.genomic-reps.dna.k31.lca.json.gz
    ```

This database was made by the representative genomes of the gtdb database

Links to an external site.. The GTDB database is also used by the tool gtdbtk, it uses marker genes and loads of data. It is a bit heavy, and tricky to run/install but much more sensitive.

    Optional: install and run gtdbtk


## Further reading

* [Recovery of nearly 8,000 metagenome-assembled genomes substantially expands the tree of life](https://www.nature.com/articles/s41564-017-0012-7)
* [The reconstruction of 2,631 draft metagenome-assembled genomes from the global oceans](https://www.nature.com/articles/sdata2017203)
