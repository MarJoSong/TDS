
# 默认动作

default :
	../z_tools/make.exe img

# 镜像文件生成

ipl.bin : ipl.nas Makefile
	../z_tools/nask.exe ipl.nas ipl.bin ipl.lst

helloos.img : ipl.bin Makefile
	../z_tools/edimg.exe   imgin:../z_tools/fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0   imgout:helloos.img

# 其他指令

asm :
	../z_tools/make.exe -r ipl.bin

img :
	../z_tools/make.exe -r helloos.img

run :
	../z_tools/make.exe img
	qemu-system-i386 -m 16M -fda helloos.img -boot a -nographic -serial mon:stdio

clean :
	-rm ipl.bin
	-rm ipl.lst
	-rm helloos.img

src_only :
	../z_tools/make.exe clean
	-rm helloos.img
