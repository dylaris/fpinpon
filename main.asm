format ELF64

section ".data" writeable

width equ 640
height equ 480
title: db "Hello, World", 0

section ".text" executable

public main

extrn InitWindow
extrn CloseWindow
extrn WindowShouldClose

main:
    push rbp
    mov rbp, rsp

    mov rdi, width
    mov rsi, height
    mov rdx, title
    call InitWindow

.begin:
    call WindowShouldClose
    cmp rax, 0
    jnz .end
    jmp .begin
.end:

    call CloseWindow

    pop rbp
    ret
