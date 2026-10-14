# SNAKE.COM for LolzDOS (16-bit, GNU as, intel syntax)
.intel_syntax noprefix
.code16
.text
.globl _start
.equ BUF, 0x4000
.equ MASK, 2047
_start:
    cld
    mov ax, 3
    int 0x10
    mov ah, 1
    mov cx, 0x2000
    int 0x10
    mov ax, 0xb800
    mov es, ax
    xor di, di
    mov cx, 80
    mov ax, 0x01DB
    rep stosw
    mov di, 24*160
    mov cx, 80
    rep stosw
    mov cx, 25
    xor di, di
    mov ax, 0x01DB
1:  mov es:[di], ax
    mov es:[di+158], ax
    add di, 160
    loop 1b
    mov ah, 0
    int 0x1a
    mov word ptr [seed], dx
    mov word ptr [tail], 0
    mov word ptr [head], 2
    mov word ptr [BUF], 0x0C26
    mov word ptr [BUF+2], 0x0C27
    mov word ptr [BUF+4], 0x0C28
    mov di, (12*80+38)*2
    mov cx, 3
2:  mov word ptr es:[di], 0x0AFE
    add di, 2
    loop 2b
    mov word ptr [hx], 40
    mov word ptr [hy], 12
    mov word ptr [dirx], 1
    mov word ptr [diry], 0
    mov word ptr [score], 0
    call showscore
    call food
game:
    call delay
    mov ah, 1
    int 0x16
    jz nokey
    xor ah, ah
    int 0x16
    cmp al, 27
    je quit
    or al, 0x20
    cmp ah, 0x48
    je kup
    cmp al, 'w'
    je kup
    cmp ah, 0x50
    je kdown
    cmp al, 's'
    je kdown
    cmp ah, 0x4B
    je kleft
    cmp al, 'a'
    je kleft
    cmp ah, 0x4D
    je kright
    cmp al, 'd'
    je kright
    jmp nokey
kup:
    cmp word ptr [diry], 1
    je nokey
    mov word ptr [dirx], 0
    mov word ptr [diry], -1
    jmp nokey
kdown:
    cmp word ptr [diry], -1
    je nokey
    mov word ptr [dirx], 0
    mov word ptr [diry], 1
    jmp nokey
kleft:
    cmp word ptr [dirx], 1
    je nokey
    mov word ptr [dirx], -1
    mov word ptr [diry], 0
    jmp nokey
kright:
    cmp word ptr [dirx], -1
    je nokey
    mov word ptr [dirx], 1
    mov word ptr [diry], 0
nokey:
    mov ax, [hx]
    add ax, [dirx]
    mov [hx], ax
    mov ax, [hy]
    add ax, [diry]
    mov [hy], ax
    mov al, byte ptr [hx]
    mov ah, byte ptr [hy]
    call offs2
    mov al, es:[di]
    cmp al, 0xDB
    je dead
    cmp al, 0xFE
    je dead
    push ax
    mov byte ptr es:[di], 0xFE
    mov byte ptr es:[di+1], 0x0A
    mov bx, [head]
    inc bx
    and bx, MASK
    mov [head], bx
    shl bx, 1
    mov al, byte ptr [hx]
    mov ah, byte ptr [hy]
    mov [bx+BUF], ax
    pop ax
    cmp al, 4
    je eat
    mov bx, [tail]
    shl bx, 1
    mov ax, [bx+BUF]
    call offs2
    mov word ptr es:[di], 0x0720
    mov bx, [tail]
    inc bx
    and bx, MASK
    mov [tail], bx
    jmp game
eat:
    inc word ptr [score]
    call showscore
    call food
    jmp game

dead:
    mov si, offset gomsg
    mov di, (12*80+30)*2
    mov bl, 0x4F
    call puts
3:  mov ah, 1
    int 0x16
    jz 4f
    xor ah, ah
    int 0x16
    jmp 3b
4:  xor ah, ah
    int 0x16
quit:
    mov ax, 3
    int 0x10
    mov ax, 0x4C00
    int 0x21

# al=x ah=y -> di = video offset
offs2:
    push ax
    push bx
    mov bl, al
    mov al, ah
    xor ah, ah
    mov bh, 80
    mul bh
    xor bh, bh
    add ax, bx
    shl ax, 1
    mov di, ax
    pop bx
    pop ax
    ret

# ds:si string, es:di dest, bl attr
puts:
    lodsb
    test al, al
    jz 1f
    mov ah, bl
    stosw
    jmp puts
1:  ret

rand:                      # cx = range -> dx
    mov ax, [seed]
    mov dx, 25173
    mul dx
    add ax, 13849
    mov [seed], ax
    xchg al, ah
    xor dx, dx
    div cx
    ret

food:
1:  mov cx, 78
    call rand
    inc dx
    mov bl, dl
    mov cx, 23
    call rand
    inc dx
    mov ah, dl
    mov al, bl
    call offs2
    cmp word ptr es:[di], 0x0720
    jne 1b
    mov word ptr es:[di], 0x0C04
    ret

showscore:
    mov si, offset title
    mov di, 4
    mov bl, 0x1E
    call puts
    mov ax, [score]
    mov bx, 10
    xor cx, cx
1:  xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz 1b
2:  pop ax
    add al, '0'
    mov ah, 0x1E
    stosw
    loop 2b
    mov ax, 0x1E20
    stosw
    ret

delay:
    mov bx, 2
1:  mov ah, 0
    int 0x1a
    mov si, dx
2:  mov ah, 0
    int 0x1a
    cmp dx, si
    je 2b
    dec bx
    jnz 1b
    ret

seed:  .word 0
head:  .word 0
tail:  .word 0
score: .word 0
hx:    .word 0
hy:    .word 0
dirx:  .word 0
diry:  .word 0
title: .asciz " LOLZ SNAKE  arrows/WASD  ESC=quit  SCORE: "
gomsg: .asciz "  GAME OVER - press a key  "
