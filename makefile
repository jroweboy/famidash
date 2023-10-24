# makefile for nesdoug example code, for Linux
# this version won't move the final files to BUILD folder
# also won't rebuild on changes to neslib/nesdoug/famitone files

ifeq ($(OS),Windows_NT)
# Windows
CC65 = ./bin/cc65.exe
CA65 = ./bin/ca65.exe
LD65 = ./bin/ld65.exe
DEL = del
else ifeq ($(OS),MSDOS)
# MS-DOS
# add "set OS=MSDOS" to autoexec
# DJGPP, GNU fileutils for DJGPP need to be installed
CC65 = ./bin/cc65d.exe
CA65 = ./bin/ca65d.exe
LD65 = ./bin/ld65d.exe
DEL = del
else
# Ubuntu/Debian
CC65 = cc65
CA65 = ca65
LD65 = ld65
DEL = rm
endif

NAME = famidash
CFG = nrom_32k_vert.cfg


.PHONY: default clean

default: $(NAME).nes


#target: dependencies

$(NAME).nes: $(NAME).o crt0.o $(CFG)
	$(LD65) -C $(CFG) -o ./BUILD/$(NAME).nes crt0.o $(NAME).o nes.lib -Ln labels.txt --dbgfile dbg.txt
	$(DEL) *.o
	@echo $(NAME).nes created

crt0.o: crt0.s famidash.chr LIB/*.s MUSIC/*.s MUSIC/*.dmc
	$(CA65) crt0.s

$(NAME).o: $(NAME).s
	$(CA65) $(NAME).s -g

$(NAME).s: $(NAME).c include.h gamemode_cube.c gamemode_ship.c Sprites.h famidash.h level_data.c BG/stereomadness_.c
	$(CC65) -Oirs $(NAME).c --add-source

clean:
ifeq ($(OS),Windows_NT)
	clean.bat
else ifeq ($(OS),MSDOS)
	rm -rf BUILD/*.*
else
	rm -rf BUILD/*.*
endif
