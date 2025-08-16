; HELLO-OS
; TAB=4

; FAT12引导扇区头部信息 - 必须严格符合规范
ORG 0X7C00  ; 加载到内存的固定地址

;-----------------------------
; BPB (BIOS PARAMETER BLOCK)
;-----------------------------
BOOT_START:
JMP SHORT START        ; 0XEB 0X4E 跳转指令
NOP                    ; 0X90 填充字节

DB 'HELLOIPL'          ; OEM标识(8字节)
DW 512                 ; 每扇区字节数 0x0200
DB 1                   ; 每簇扇区数
DW 1                   ; 保留扇区数(FAT1起始位置)
DB 2                   ; FAT表数量
DW 224                 ; 根目录项数   0x00e0
DW 2880                ; 总扇区数(1.44MB软盘)   0x0b40
DB 0xf0                ; 介质描述符
DW 9                   ; 每FAT扇区数
DW 18                  ; 每磁道扇区数   0x0012
DW 2                   ; 磁头数
DD 0                   ; 隐藏扇区数
DD 2880                ; 大容量扇区数(备份)

;-----------------------------
; EXTENDED BPB
;-----------------------------
DB 0x00                ; 物理驱动器号
DB 0x00                ; 保留
DB 0x29                ; 扩展引导标记
DD 0xffffffff          ; 卷序列号
DB 'HELLO-OS   '       ; 卷标(11字节)
DB 'FAT12   '          ; 文件系统类型(8字节)

;-----------------------------
; 引导代码主体(实模式16位)
;-----------------------------
START:
; 初始化段寄存器
MOV AX, 0              ; b8 00 00
MOV SS, AX             ; 设置栈段寄存器(SS)=0 8e d0
MOV SP, 0X7C00         ; 栈指针设为加载地址 bc 00 7c
MOV DS, AX             ; 设置数据段寄存器(DS)=0 8e d8
MOV ES, AX             ; 设置扩展段寄存器(ES)=0 8e c0
MOV SI, MSG            ; SI指向字符串地址(0x7C74) 8e 74 7c

PRINT_LOOP:
;MOV AL, [SI]          ; AL=字符串首字节 8a 04
;ADD SI, 1             ; SI指针递增 83 c6 01
LODSB                  ; 加载SI指向的字节到AL，SI指针递增
CMP AL, 0              ; 检查字符串结束符 3c 00
JE  HALT               ; 如果为0则跳转到HLT
MOV AH, 0x0e           ; BIOS显示功能号 b4 0e
MOV BX, 0x000F         ; 显示属性(黑底白字) bb 0f 00
INT 0x10               ; 调用BIOS显示中断 cd 10
JMP PRINT_LOOP         ; 跳回继续处理下一个字符 eb ee

HALT:
HLT                    ; 停止CPU执行
JMP HALT               ; 无限循环(HLT)

; 数据区
MSG:
DB 0x0a, 0x0a    ; 两个换行
DB 'hello, world'
DB 0x0a          ; 换行
DB 0             ; 字符串结束符

; 填充到510字节
TIMES 0x1fe-($-$$) DB 0 ; 当前地址-其实地址小于510时填充0

; 引导扇区标志
DB 0x55, 0xaa

;-----------------------------
; 后续扇区填充(FAT区域模拟)
;-----------------------------
; 第一个FAT表(必需)
FAT1:
DB 0xf0, 0xff, 0xff, 0x00
TIMES 4600-($-FAT1) DB 0

; 第二个FAT表(可选)
FAT2:
DB 0xf0, 0xff, 0xff, 0x00
TIMES 1469432-($-FAT2) DB 0
