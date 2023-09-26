## AS2650 Con Badge

Repo containing all the files for my latest con badge, using one of my GFMPW-0 ICs.

`HW` contains the KiCad project for the hardware.

`NB_Firmware` contains the management controller firmware.

`CPLD` contains the Quartus project for the CPLD on the board.

`Verilog` contains a complete Verilog model of the whole board, including the LED screen (requires gtkmm-4.0 to display).

`Software` is the actual meat of the project - all the code running on the badge.

`Bitmaps` contains all image assets to be placed into ROM.

Some misc stuff:

`ObjParser.java` converts .obj 3D model files to the format used by my rasterizer implementation.

`ROM_layout` visualizes the layout of the SPI flash accessible by the AS2650.

`ROMGlue` is a very long script that grabs all the different built binaries and asset files, and puts it also into a single ROM image, according to the documented layout.

`Avali.bin` is the 3D model data rendered by one of the demos.

There is also a (very ugly) Makefile to build parts of the project.
