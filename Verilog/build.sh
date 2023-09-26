#!/bin/bash

set -e

CFLAGS=$(pkg-config gtkmm-4.0 --cflags)
LDFLAGS=$(pkg-config gtkmm-4.0 --libs)
TRACE_FLAGS="--trace-depth 3 --trace -DTRACE_ON -CFLAGS '-DTRACE_ON'"
verilator -DBENCH -Wno-fatal --timing --top-module tb -cc -exe ${TRACE_FLAGS} bench.cpp tb.v as2650.v AS7C256.v CPLD.v computer.v IS61LV256.v LED_Panel.v MCP1319MT.v SN74LVC8T245.v nes_controller.v spiflash.v -CFLAGS "$CFLAGS" -LDFLAGS "$LDFLAGS"
cd obj_dir
make -f Vtb.mk
cd ..
