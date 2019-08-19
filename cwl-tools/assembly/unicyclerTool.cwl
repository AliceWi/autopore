#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: unicycler
label: Creates a de novo genome assembly from short or long reads or from a combination of both.
doc: |
  Uses the unicycle assembly pipeline to assemble bacterial genomes from Illumina reads using SPAdes or PacBio/Nanopore reads using miniasm and racon. If short (Illumina) and long (PacBio/Nanopore) reads are both provided, a hybrid assembly will be created.

hints:
  DockerRequirement:
    dockerPull: ttubb/unicycler:release-0.2.0
  SoftwareRequirement:
    packages:
      unicycler:
        specs: [ "https://github.com/rrwick/Unicycler" ]
        version: [ "0.4.7" ]
      spades:
        specs: [ "https://identifiers.org/RRID:SCR_000131" ]
        version: [ "3.13.0" ]
      racon:
        specs: [ "https://github.com/isovic/racon" ]
        version: [ "1.3.3" ]
      pilon:
        specs: [ "https://identifiers.org/RRID:SCR_014731" ]
        version: [ "1.23" ]
      bowtie2:
        specs: [ "http://gensoft.pasteur.fr/docs/bowtie2/2.2.6/" ]
        version: [ "2.3.5.1" ]
      samtools:
        specs: [ "https://identifiers.org/RRID:SCR_002105" ]
        version: [ "1.7" ]
      blastplus:
        specs: [ "http://nebc.nox.ac.uk/bioinformatics/docs/blast+.html" ]
        version: [ "2.6.0" ]      

requirements:
  InlineJavascriptRequirement: {}
    
inputs:
  out_dir_name:
    label: Name given to the output directory of this tool.
    type: string?
    default: unicycler_hybrid_assembly
    inputBinding:
      prefix: --out
  short_reads_fwd:
    label: Forward short reads.
    type: File?
    inputBinding:
      prefix: --short1
  short_reads_rev:
    label: Reverse short reads.
    type: File?
    inputBinding:
      prefix: --short2
  short_reads_unpaired:
    label: Unpaired short reads.
    type: File?
    inputBinding:
      prefix: --unpaired
  long_reads:
    label: File with basecalled nanopore or PacBio reads.
    type: File?
    inputBinding:
      prefix: --long
  worker_threads:
    label: CPU-threads used by tool.
    type: int?
    default: 8
    inputBinding:
      prefix: --threads
  bridging_mode:
    label: |
      Bridging mode. Has to be set to conservative, normal or bold
      conservative:  smaller contigs, lowest missassembly rate
      bold: longest contigs, higher missassembly rate
    type: string?
    default: normal
    inputBinding:
      prefix: --mode
  min_contig_length:
    label: Exclude contigs shorter than this length from output fasta file.
    type: int?
    inputBinding:
      prefix: --min_fasta_length
  linear_sequences:
    label: Expected number of non-circular sequences in underlying sequence.
    type: int?
    default: 0
    inputBinding:
      prefix: --linear_seqs

outputs:
  assembly_dir:
    label: Directory containing all output generated by unicycler.
    type: Directory
    outputBinding:
      glob: $(inputs.out_dir_name)
  contigs:
    label: Fasta file with contigs assembled and polished by unicycler.
    type: File
    outputBinding:
      glob: $((inputs.out_dir_name)+"/assembly.fasta")
  contigs_graph:
    label: gfa file with contigs assembled and polished by unicycler.
    type: File
    outputBinding:
      glob: $((inputs.out_dir_name)+"/assembly.gfa")
  logfile:
    label: File containing the stdout unicycler generates while running.
    type: File
    outputBinding:
      glob: $((inputs.out_dir_name)+"/unicycler.log")

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-03-10"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"
  edam: "http://edamontology.org/"

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
