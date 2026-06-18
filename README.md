### Docker files to create PRISMS-PF Docker images

To create images use the provided Makefile.

Here are the available commands
-`minimal-dependencies-amd64`: Create the minimal dependency images with amd64 architecture
-`minimal-dependencies-arm64`: Create the minimal dependency images with arm64 architecture
-`minimal-dependencies`: Create the minimal dependency images with amd64 and arm64 architectures
-`all`: Create all images

Minimal dependencies contains the bare minimum for PRISMS-PF to compile and is the most lightweight image.
