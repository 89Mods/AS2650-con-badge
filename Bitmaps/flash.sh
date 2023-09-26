#!/bin/bash
set -e
flashrom --programmer ch341a_spi -w compiled.bin
