---
title: "Reflections on Genomic Data Science"
description: "A beginner-friendly overview of DNA sequencing basics, inspired by the Coursera Genomic Data Science specialization, plus thoughts on the moral implications of genetic editing."
date: 2025-11-16
draft: false
tags: ["genomics", "bioinformatics", "ethics", "DNA sequencing", "CRISPR"]
cover:
  image: "images/blog/02112025.jpg"
  alt: "Illustration of DNA sequencing process"
  caption: "DNA sequencing workflow"
  credit: "Coursera; Johns Hopkins University"
toc: true
featured: true
---
## TL;DR

DNA sequencing breaks a sample into fragments, reads one strand using light-emitting reactions (captured iteratively via screenshots), and reconstructs the full genome computationally. We get a simple text file with sequence ID, bases (A/T/G/C), and quality scores. This unlocks powerful analysis—but also raises profound ethical questions about editing human genetics.

## Key Takeaways

- DNA is double-stranded with strict pairing rules: **A** always pairs with **T**, **G** with **C**. Sequencing one strand is enough to infer the other.
- Modern sequencing (e.g., Illumina) uses *sequencing by synthesis*: nucleotides emit colored light when added, and cameras capture each step.
- Output is a FASTQ file: sequence ID, bases, and Phred quality scores (encoded as ASCII characters derived from error probabilities).
- Fragments are assembled computationally into full genomes.
- With great power comes great responsibility: full genomes enable editing (e.g., fixing chromosomal abnormalities), but where do we draw moral lines?

## Introduction

Completing the *Genomic Data Science* specialization on Coursera (offered by Johns Hopkins University) left me in deep reflection. The course demystified how we turn a biological sample into actionable digital data—and what that capability truly means for humanity.

Below, I’ll break down the core process in plain language, then share the ethical questions it sparked.

## How DNA Sequencing Works (Simplified)

1. **Sample Preparation**  
   A DNA sample is extracted and *denatured* (split into single strands) using heat or chemicals. We work with just **one strand** per molecule—why? Because of base-pairing rules:  
   - **A** ↔ **T**  
   - **G** ↔ **C**  
   Knowing one strand lets us reconstruct the complementary one automatically.

2. **Amplification & Fragmentation**  
   The strand is amplified millions of times using **PCR** (Polymerase Chain Reaction). It’s then randomly broken into short fragments (100–300 base pairs) for parallel processing.

3. **Sequencing by Synthesis**  
   Fragments are immobilized on a flow cell. Fluorescently labeled nucleotides are added one at a time:  
   - When a base binds, it emits a specific color of light (e.g., A = green, T = red).  
   - A high-resolution camera takes a “snapshot” after each cycle.  
   - This repeats for every position in the fragment—building the sequence base by base.

4. **Data Output (FASTQ Format)**  
   Here’s a real example from a lecture:
  ```
  @ERR266411.1 HS18_09233:8:1307:10911:3848#168/1
  TAAACAAGCAGTAGTAATTCCTGCTTTATCAAGATAATTTTTCGACTCATCAGAAATATCCGAAAGTGTTAACTTCTGCGTCATGGAAGCGATAAAACTC
  +
  B@DFEFFFGEGGGHEHGHGHGGGGHIFGFIFHICFGHGHGJGHFGHGIHEHGGHJGFEFHGHEGGHHGHIFGFGDIFGGFGGGFHGGGHGGGAGIFGGCG
  ```
  - **Line 1**: Read identifier  
  - **Line 2**: DNA sequence (one strand only)  
  - **Line 3**: Separator (`+`)  
  - **Line 4**: **Phred quality scores**— each character represents the confidence in the corresponding base. Higher ASCII value = lower error probability.  
  *Formula*: `Phred = -10 * log₁₀(P_error)` → encoded as ASCII (e.g., `!` = Phred 0, `~` ≈ Phred 40).

5. **Assembly & Analysis**  
Millions of overlapping fragments are aligned computationally to reconstruct the full genome. Tools like Bowtie, BWA, or GATK handle alignment, variant calling, and annotation.

## The Big Picture: From Reading to Writing DNA

We’ve sequenced humans, animals, plants, and microbes. The pipeline is now routine:

- **Take sample** → **Amplify & sequence** → **Generate fragments** → **Align & assemble** → **Analyze**

This blog isn’t a tutorial—it’s a spark. The real mind-bender? **We can now *write* DNA as easily as we read it.**

## Ethical Crossroads

> *"The most important questions are the ones we haven’t asked yet."*

Consider **Down syndrome** (trisomy 21): an extra chromosome 21. Most aneuploidies (missing/extra chromosomes) cause miscarriage. What if we could:

```pseudo
if (chromosome_count[21] > 2) {
 remove_excess();
} else if (chromosome_count[21] < 2) {
 repair();
} else {
 approve();
}
```
A simple conditional —like code. But:

**Is it right to “fix” a genome before birth?
Who decides what’s a defect? Intelligence? Height? Behavior?**

Cultural bias: Some nations might mandate edits; others ban them. Who arbitrates?

Unintended consequences: History shows “war heroes” rarely ask permission. CRISPR babies (2018) proved we can edit embryos—regulation lags behind capability.

We stand at a threshold: prevent suffering vs. play God. The technology is neutral. The choices are not.