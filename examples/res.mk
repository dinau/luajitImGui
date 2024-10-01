RSC_NAME = rsc

.PHONY: res32 res64 clean png

all: clean res

res: res64
	@#png2ico  img/imguin.ico ../icon.png

res32: $(RSC_NAME)32.res
res64: $(RSC_NAME)64.res

$(RSC_NAME)32.res: $(RSC_NAME).rc
	windres -O coff $< -o $@

$(RSC_NAME)64.res: $(RSC_NAME).rc
	windres -O coff $< -o $@

png:
	pip install qrcode
	qr https://github.com/dinau/imguin > img/imguin.png

clean:
	@-rm $(RSC_NAME)32.res $(RSC_NAME)64.res
