<div align="center">
  <h1>Cmake Starter</h1>
  <img src="https://github.com/mattcoding4days/cmake-starter/actions/workflows/cmake.yml/badge.svg?branch=dev">
</div>

> A lightweight Cmake project meant for a binary application (not a shared library), tests with catch2 are
> configured, CPM is the package manager of choice, docopt and fmtlib are installed and linked as libraries


## Docker
This container builds the development environment for Ubuntu 20.04

Build image using:  
`docker build -t <image-namge>:<tag> .`

SSH into the container using:  
`docker run -it <image-name>:<tag>`
