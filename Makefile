# Makefile for Allwinner Babelfish FEX-to-DT translator
CC		:= $(CROSS_COMPILE)gcc
OBJCOPY		:= $(CROSS_COMPILE)objcopy
LD		:= $(CROSS_COMPILE)ld
DTC		:= dtc

CFLAGS		:= -Wall -ffreestanding
CFLAGS		+= -I$(CURDIR)/include -I$(CURDIR)/include/generated

LOADADDR	:= 0x40008000

LDFLAGS		:= -static -nostdlib
LDFLAGS		+= -T babelfish.lds
LDFLAGS		+= -Ttext $(LOADADDR)

OBJS		:=
DTBS		:=

define my-dir
$(dir $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
endef

include src/Makefile
OBJS += $(addprefix $(FILE_PATH), $(FILE_OBJS))
OBJS := $(addprefix out/, $(OBJS))

include dtsi/Makefile
DTBS += $(addprefix $(FILE_PATH), $(FILE_DTBS))
DTBS := $(addprefix out/, $(DTBS))

out/%.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c -o $@ $^

out/%.dtb: %.dtsi
	mkdir -p $(dir $@)
	$(DTC) -I dts -O dtb -o $@ $^
	(cd $(dir $@); \
	$(OBJCOPY) -I binary -O elf32-littlearm -B arm \
		--rename-section .data=.$(notdir $*) $(notdir $@) $(notdir $@);)

version.h:
	mkdir -p include/generated
	./genver.sh > include/generated/version.h

babelfish: version.h $(OBJS) $(DTBS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(DTBS)

babelfish.bin: babelfish
	$(OBJCOPY) -O binary --set-section-flags .bss=alloc,load,contents $^ $@

all: uImage
uImage: babelfish.bin
	mkimage -A arm -O linux -C none -T kernel \
		-a $(LOADADDR) -e $(LOADADDR) \
		-n "Allwinner BabelFish" -d $^ $@

clean:
	rm -fr babelfish babelfish.bin include/generated out uImage