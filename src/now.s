# NOW.COM - prints current date and time
.intel_syntax noprefix
.code16
.text
.globl _start
_start:
    mov dx, offset fname
    mov ax, 0x3D00
    int 0x21
    jc 9f
    mov bx, ax
    mov dx, offset cfg
    mov cx, 16
    mov ah, 0x3F
    int 0x21
    mov [cfgn], ax
    mov ah, 0x3E
    int 0x21
    mov dx, offset t0
    mov ah, 9
    int 0x21
    mov bx, 1
    mov cx, [cfgn]
    mov dx, offset cfg
    mov ah, 0x40
    int 0x21
    mov dx, offset crlf
    mov ah, 9
    int 0x21
    mov ax, 0x4C00
    int 0x21
9:
    mov ah, 0x2A
    int 0x21
    mov [yr], cx
    mov [mo], dh
    mov [dy], dl
    mov ah, 0x2C
    int 0x21
    mov [hh], ch
    mov [mm], cl
    mov [secs], dh
    mov dx, offset t1
    mov ah, 9
    int 0x21
    mov ax, [yr]
    mov bl, 100
    div bl
    mov [tmp], ah
    call p2
    mov al, [tmp]
    call p2
    mov dl, '-'
    call pc
    mov al, [mo]
    call p2
    mov dl, '-'
    call pc
    mov al, [dy]
    call p2
    mov dx, offset t2
    mov ah, 9
    int 0x21
    mov al, [hh]
    call p2
    mov dl, ':'
    call pc
    mov al, [mm]
    call p2
    mov dl, ':'
    call pc
    mov al, [secs]
    call p2
    mov dx, offset crlf
    mov ah, 9
    int 0x21
    mov ax, 0x4C00
    int 0x21
pc:
    mov ah, 2
    int 0x21
    ret
p2:
    xor ah, ah
    mov bl, 10
    div bl
    push ax
    add al, '0'
    mov dl, al
    call pc
    pop ax
    mov dl, ah
    add dl, '0'
    call pc
    ret
yr: .word 0
mo: .byte 0
dy: .byte 0
hh: .byte 0
mm: .byte 0
secs: .byte 0
tmp:.byte 0
t1: .ascii "Date: $"
t2: .ascii "   Time: $"
crlf: .ascii "\r\n$"
fname: .asciz "C:\\LOLZDATE.CFG"
t0: .ascii "LolzDOS clock: $"
cfgn: .word 0
cfg: .space 20
