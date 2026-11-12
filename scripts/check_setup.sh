#!/usr/bin/env bash
# Checks that this computer is ready for the local tutorials of the course.
# Run it from the course folder with:   pixi run check
# Licence: MIT (see LICENSE-code).

SETUP_PAGE="https://rvandamme.github.io/Metagenomics_course/setup.html"
problems=0
warnings=0
ok()      { echo "  OK       $1"; }
warning() { echo "  WARNING  $1"; warnings=$((warnings + 1)); }
problem() { echo "  PROBLEM  $1"; problems=$((problems + 1)); }

course_dir="$(cd "$(dirname "$0")/.." && pwd)"
system="$(uname -s)"

echo
echo "1. Tools of the main environment"
if [ -z "$CONDA_PREFIX" ]; then
    problem "No environment is active. Run this check with: pixi run check"
else
    tools="fastqc fastp multiqc seqkit kraken2 krakentools krona sickle-trim megahit bowtie2 samtools metabat2 sourmash"
    if [ "$system" = "Linux" ]; then tools="$tools bracken"; fi
    for tool in $tools; do
        file=$(ls "$CONDA_PREFIX"/conda-meta/"$tool"-[0-9]*.json 2>/dev/null | head -n 1)
        if [ -n "$file" ]; then
            version=$(basename "$file" .json | sed "s/^$tool-//; s/-[^-]*\$//")
            ok "$tool $version"
        else
            problem "$tool is missing. In the course folder, run: pixi install --all"
        fi
    done
fi

echo
echo "2. Other environments"
environments="checkm1 checkm2 prokka"
if [ "$system" = "Darwin" ]; then environments="$environments bracken-mac"; fi
for environment in $environments; do
    if [ -d "$course_dir/.pixi/envs/$environment" ]; then
        ok "environment '$environment' is installed"
    else
        problem "environment '$environment' is not installed. In the course folder, run: pixi install --all"
    fi
done

echo
echo "3. Memory (the tutorials need 6 GB)"
if [ "$system" = "Linux" ]; then
    memory_mb=$(awk '/^MemTotal/ {printf "%d", $2 / 1024}' /proc/meminfo)
else
    memory_mb=$(( $(sysctl -n hw.memsize) / 1024 / 1024 ))
fi
memory_gb=$(awk -v m="$memory_mb" 'BEGIN {printf "%.1f", m / 1024}')
if [ "$memory_mb" -ge 5500 ]; then
    ok "$memory_gb GB of memory"
elif grep -qi microsoft /proc/version 2>/dev/null; then
    problem "WSL has only $memory_gb GB of memory. Give WSL 6 GB: see 'Give WSL 6 GB of memory' on $SETUP_PAGE"
else
    problem "This computer has only $memory_gb GB of memory. Some steps will stop. Tell your teacher."
fi

echo
echo "4. Free disk space in your home folder (about 30 GB are needed for tools, databases and results)"
free_gb=$(df -Pk "$HOME" | awk 'NR == 2 {printf "%d", $4 / 1024 / 1024}')
if [ "$free_gb" -ge 30 ]; then
    ok "$free_gb GB free"
elif [ "$free_gb" -ge 15 ]; then
    warning "$free_gb GB free. This is enough if the tools and databases are already installed. Otherwise free some space."
else
    problem "Only $free_gb GB free. Free some disk space before you download the databases."
fi

echo
echo "5. Location of the course folder"
case "$course_dir" in
    /mnt/*)
        problem "The course folder is on the Windows drive ($course_dir). Tools are very slow there. Move it to your Linux home, for example ~/mag2026/" ;;
    *" "*)
        problem "The path of the course folder contains a space ($course_dir). Move it to a path without spaces, for example ~/mag2026/" ;;
    *)
        ok "$course_dir" ;;
esac

echo
if [ "$problems" -eq 0 ] && [ "$warnings" -eq 0 ]; then
    echo "Everything is ready."
elif [ "$problems" -eq 0 ]; then
    echo "Ready, with $warnings warning(s). Read them above."
else
    echo "$problems problem(s) and $warnings warning(s). Fix the problems, then run 'pixi run check' again."
    echo "Help: $SETUP_PAGE"
fi
exit "$problems"
