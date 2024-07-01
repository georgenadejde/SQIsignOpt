# Implementation of SQISign with verification improvements

Accompanying paper "**Improving AprèsSQI's cost model for verification.**".

## Overview

This repository contains the following features regarding verification:

- Non-square x-coordinates (LWXZ).
- xMUL with adds (replace fp2_mul's with additions for points with small coordinates).
- xMUL with conjugate trick (change a point's coordinates by multiplying with conjugate of Z).

## Benchmarking xMUL

We have also added global variables to benchmark indvidual xMUL's.

## Supported primes

The optimizations currently work only on the default prime  `p3923`.

## Compile, test and benchmark

```
make
make check
make benchmark
```

To only benchmark verification, do 

`make bench_verif && ./build/p3923/bench/verif verif.tsv`

## Benchmark on multiple samples

To run the verification multiple times, we provide two scripts:

- `compile_bench.sh` -> compile and benchmark verification without xMUL difference
- `bench_with_diff.sh` -> benchmark verification with xMUL difference
