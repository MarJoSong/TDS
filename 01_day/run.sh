# 小内存即可，加载软盘镜像，从软盘启动，无图形界面，终端交互
qemu-system-i386 -m 16M -fda helloos.img -boot a -nographic -serial mon:stdio
