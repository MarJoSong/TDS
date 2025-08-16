@echo off
../z_tools/make.exe -r -C ../z_tools/osa_qemu
if %1.==. goto def_opt
if %1.==.. goto no_opt
cp %1.bin ../z_tools/!built.bin
../z_tools/edimg.exe @../z_tools/edimgopt.txt
if errorlevel 1 goto end
goto qemu
:def_opt
../z_tools/edimg.exe @!run_opt.txt
if errorlevel 1 goto end
goto qemu
:no_opt
cp ../z_tools/osa_qemu/osaimgqe.bin ../z_tools/qemu/fdimage0.bin
:qemu
../z_tools/make.exe -r -C ../z_tools/qemu
:end
