baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
id: platypus-2
inputs:
  input:
    doc: List of BAM files
    inputBinding:
      position: 1
      prefix: --input
    type: File
label: Platypus
outputs:
  VariantCalls:
    doc: 'Output VCF '
    outputBinding:
      glob: VariantCalls/*
    type: File
requirements:
- class: DockerRequirement
  dockerOutputDirectory: /data/out
  dockerPull: pfda2dockstore/platypus-2:8
s:author:
  class: s:Person
  s:name: Lichy Han
