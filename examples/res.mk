RSC_NAME = rsc

.PHONY: res

all: res

res: $(RSC_NAME)32.res $(RSC_NAME)64.res
	@#png2ico  img/imguin.ico ../icon.png

$(RSC_NAME)32.res: $(RSC_NAME).rc
	windres -O coff $< -o $@

$(RSC_NAME)64.res: $(RSC_NAME).rc
	windres -O coff $< -o $@

png:
	pip install qrcode
	qr https://github.com/dinau/imguin > img/imguin.png

clean:
	@-rm $(RSC_NAME)32.res $(RSC_NAME)64.res
