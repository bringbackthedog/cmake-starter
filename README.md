<div align="center">
  <h1>Cmake Starter</h1>
  <img src="https://github.com/mattcoding4days/cmake-starter/actions/workflows/cmake.yml/badge.svg?branch=dev">
</div>

## About 

> A lightweight Cmake project meant for a binary application (not a shared library), tests with catch2 are
> configured, CPM is the package manager of choice, docopt and fmtlib are installed and linked as libraries

## Docker

> This container builds the development environment for Ubuntu 20.04,
> installs the cmake project, and then runs the tests

### :keyboard: Commands

```bash
# Build the container (can be used to rebuild image after code changes)
# [e.g] docker image build -t <image-name>:<tag> .
docker image build -t cm:v0.1 .

# Rebuild with no cache
docker image build --no-cache -t cm:v0.1 .

# Run the container interactively
# [e.g] docker container run -it <image-name>:<tag>
docker container run -it cm:v0.1

# Run non interactively
docker container run cm:v0.1
```
