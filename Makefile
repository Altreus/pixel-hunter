.PHONY: dist win64 linux clean

clean:
	- $(RM) dist/pixel-hunter.love
	- $(RM) pixel-hunter.love
	- $(RM) dist/pixel-hunter-*.zip

pixel-hunter.love:
	zip -9 -r pixel-hunter.love main.lua class.lua geometry.lua level.lua scaler.lua vectorial2.lua conf.lua ui img

dist: pixel-hunter.love
	mv pixel-hunter.love dist

linux: dist

win64: dist
	cat dist/love-11.3-win64/love.exe dist/pixel-hunter.love > dist/pixel-hunter-0.001-win64/pixelhunter.exe
	cd dist && zip -9 -r pixel-hunter-0.001-win64.zip pixel-hunter-0.001-win64
