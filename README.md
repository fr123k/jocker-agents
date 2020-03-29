[![Build Status](https://travis-ci.com/fr123k/jocker-agents.svg?branch=master)](https://travis-ci.com/fr123k/jocker)
[![dockeri.co](https://dockeri.co/image/fr123k/jocker-agents-golang)](https://hub.docker.com/r/fr123k/jocker-agents-golang)

# jocker-agents

## Introduction

This repository provide jenkins docker agents images that are ready to use with jocker to 
in [jocker](https://github.com/fr123k/jocker).

## Agents

### Golang

This docker image provide an ready to use jnlp jenkins agents with golang support.

* installed make
* installed golang 1.12

### Pulumi

This docker image provide an ready to use jnlp jenkins agents with pulumi support.

* installed make
* installed golang 1.12
* installed pulumi 1.13.x
* installed pwgen
* installed jq

### Packer

This docker image provide an ready to use jnlp jenkins agents with pulumi support.

* installed make
* installed packer 1.5.5

## Build

```bash
make build
```

## TODO

* setup GOPATH as volume to support mount for caching
