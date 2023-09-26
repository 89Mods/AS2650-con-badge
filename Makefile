all: boot.bin ba.bin snake.bin badge.bin compiled.bin

boot.bin:
	cd Software && dotnet run asm Bootloader/boot.asm
	cp Software/Bootloader/boot.txt Verilog/

root.bin:
	cd Software && dotnet run asm RootPGM/root.asm

badge.bin:
	cd Software && dotnet run asm BadgeIdle/badge.asm
	cd Software && dotnet run asm BadgeIdle/badge_highmem.asm
	cd Software && dotnet run asm BadgeIdle/three_dee.asm

ba.bin:
	cd Software && dotnet run asm BA/ba.asm
	cd Software/BA && java FramesToROM.java

snake.bin:
	cd Software && dotnet run asm Snake/snake.asm

ROMGlue:
	javac ROMGlue.java

compiled.bin: root.bin ROMGlue
	java ROMGlue Software/RootPGM/root.bin
	cp compiled.txt Verilog/

.PHONY: all
