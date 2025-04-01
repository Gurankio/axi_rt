# A real-time extension for AMBA AXI4 protocol
[![CI status](https://github.com/pulp-platform/axi_rt/actions/workflows/gitlab-ci.yml/badge.svg?branch=master)](https://github.com/pulp-platform/axi_rt/actions/workflows/gitlab-ci.yml?query=branch%3Amaster)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/pulp-platform/axi_rt?color=blue&label=current&sort=semver)](CHANGELOG.md)
[![SHL-0.51 license](https://img.shields.io/badge/license-SHL--0.51-green)](LICENSE)

This repository provides a modular real-time extension for AXI4-based memory systems. AXI-RT is part
of the [PULP (Parallel Ultra-Low-Power) platform](https://pulp-platform.org/). It is independent of
the specific AXI4 implementation used. However, it is primarily intended to be used with our
[AXI4+ATOP implementation](https://github.com/pulp-platform/axi).

## License
AXI-RT is released under Solderpad v0.51 (SHL-0.51) see [`LICENSE`](LICENSE):

## Getting Started

Without [vivamir](https://github.com/Gurankio/vivamir) installed:
```
vivado -mode tcl 
> source vivamir/project.tcl
```

or with [vivamir](https://github.com/Gurankio/vivamir) installed:
```
vivamir open vivado
```

This will create a new project with a sample design with 3 AXI Traffic Generator individually limited.
Both a synthetizable design and a simulation design with a BRAM are already available.

## AXI-REALM Structure

There are 2 modules a "device" module and a "master" module that coordinates a number of "device" modules.

Each device module can be configured to support a number of ports and is responsible for tracking the available budget.
The master module is instead responsible for coordinating budget increments, achieving maximum bandwidth utilization through budget reclaiming.

A constant configurator is available as a module to configure the AXI-REALM unit without PS.
Using the reclaiming to the maximum, it is enough to simply configure the minimum ratio needed for each device.
I.e.: 3 devices with equal share => set budget to 1 for everyone.

See my bachelor thesis [here](https://github.com/Gurankio/bachelor-thesis) (in italian).
