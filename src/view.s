# VIEW.COM - paged text viewer: VIEW FILE.TXT
.intel_syntax noprefix
.code16
.text
.globl _start
.equ BUF, 0x2000
_start:
    mov si, 0x81
1:  mov al, [si]
    cmp al, ' '
    jne 2f
    inc si
    jmp 1b
2:  cmp al, 0x0D
    je usage
    mov dx, si
3:  mov al, [si]
    cmp al, 0x0D
    je 4f
    inc si
    jmp 3b
4:  mov byte ptr [si], 0
    mov ax, 0x3D00
    int 0x21
    jc nofile
    mov bx, ax
    mov dx, BUF
    mov cx, 30000
    mov ah, 0x3F
    int 0x21
    mov [len], ax
    mov ah, 0x3E
    int 0x21
    mov si, BUF
    mov cx, [len]
    mov byte ptr [lines], 0
p:  test cx, cx
    jz done
    lodsb
    dec cx
    cmp al, 0x1A
    je done
    mov dl, al
    mov ah, 2
    int 0x21
    cmp dl, 0x0A
    jne p
    inc byte ptr [lines]
    cmp byte ptr [lines], 23
    jb p
    mov byte ptr [lines], 0
    push cx
    mov dx, offset more
    mov ah, 9
    int 0x21
    mov ah, 8
    int 0x21
    pop cx
    cmp al, 27
    je done
    mov dx, offset crlf
    mov ah, 9
    int 0x21
    jmp p
usage:
    mov dx, offset musage
    jmp say
nofile:
    mov dx, offset mnofile
say:
    mov ah, 9
    int 0x21
done:
    mov ax, 0x4C00
    int 0x21
len:    .word 0
lines:  .byte 0
more:   .ascii "\r\n-- More (any key, ESC=quit) --$"
crlf:   .ascii "\r\n$"
musage: .ascii "Usage: VIEW filename\r\n$"
mnofile:.ascii "File not found\r\n$"
