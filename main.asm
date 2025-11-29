format ELF64

section ".data" writeable

struc Color r, g, b, a {
    .r db r
    .g db g
    .b db b
    .a db a
}

width  equ 640
height equ 480
title db "Hello, World", 0
white       Color 255, 255, 255, 255
green       Color 38,  185, 154, 255
dark_green  Color 20,  160, 133, 255
light_green Color 129, 204, 184, 255
yellow      Color 243, 213, 91,  255
circle_radius dd 75.0

section ".text" executable

public main

extrn InitWindow
extrn CloseWindow
extrn WindowShouldClose
extrn BeginDrawing
extrn EndDrawing
extrn ClearBackground
extrn DrawRectangle
extrn DrawLine
extrn DrawCircle

draw_background:
    push rbp
    mov rbp, rsp

    xor rdi, rdi
    mov edi, DWORD [dark_green]
    call ClearBackground

    mov rdi, 0
    mov rsi, 0
    mov rdx, width/2
    mov rcx, height
    xor r8, r8
    mov r8d, DWORD [green]
    call DrawRectangle

    mov rdi, width/2
    mov rsi, height/2
    movss xmm0, DWORD [circle_radius]
    xor rdx, rdx
    mov edx, [light_green]
    call DrawCircle

    mov rdi, width/2
    mov rsi, 0
    mov rdx, width/2
    mov rcx, height
    xor r8, r8
    mov r8d, DWORD [white]
    call DrawLine

    pop rbp
    ret

main:
    push rbp
    mov rbp, rsp

    mov rdi, width
    mov rsi, height
    mov rdx, title
    call InitWindow

.event_loop:
    call WindowShouldClose
    test rax, rax
    jnz .exit

    call BeginDrawing

    call draw_background

    call EndDrawing

    jmp .event_loop

.exit:
    call CloseWindow

    pop rbp
    ret
