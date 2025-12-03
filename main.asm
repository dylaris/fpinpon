format ELF64

section ".data" writeable

struc Color r, g, b, a {
    .r db r
    .g db g
    .b db b
    .a db a
}

struc Ball {
    .x dd 100
    .y dd 100
    .r dd 10
    .dx dd 1
    .dy dd 1
}

width  equ 640
height equ 480
title db "Hello, World", 0
fps    equ 60

white       Color 255, 255, 255, 255
green       Color 38,  185, 154, 255
dark_green  Color 20,  160, 133, 255
light_green Color 129, 204, 184, 255
yellow      Color 243, 213, 91,  255

circle_radius dd 75.0

ball        Ball

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
extrn SetTargetFPS

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

draw_ball:
    push rbp
    mov rbp, rsp

    xor rdi, rdi
    mov edi, DWORD [ball.x]
    xor rsi, rsi
    mov esi, DWORD [ball.y]
    cvtsi2ss xmm0, DWORD [ball.r]
    xor rdx, rdx
    mov edx, [white]
    call DrawCircle

    pop rbp
    ret

;; int check_limit(int x, float r, int limit);
check_limit:
    push rbp
    mov rbp, rsp

    ;; x - r <= 0
    mov eax, edi
    sub eax, esi
    cmp eax, 0
    jle .left

    ;; x + r >= limit
    mov eax, edi
    add eax, esi
    cmp eax, edx
    jge .right

.ok:
    mov eax, 0
    jmp .end

.left:
    mov eax, -1
    jmp .end

.right:
    mov eax, 1

.end:
    pop rbp
    ret

;; void update_ball_helper(int *x, int *dx, int limit);
update_ball_helper:
    push rbp
    mov rbp, rsp

    ;; ball.x += ball.dx
    mov eax, DWORD [edi]
    add eax, DWORD [esi]
    mov [edi], eax

    push rdi
    push rsi
    push rdx

    mov edi, eax
    mov esi, DWORD [ball.r]
    ;; edx is limit
    call check_limit

    pop rdx
    pop rsi
    pop rdi

    cmp eax, 0
    jz .x_ok

    push rax

    ;; ball.dx *= -1
    mov eax, DWORD [esi]
    neg eax
    mov [esi], eax

    pop rax

    cmp eax, 0
    jl .x_left

    cmp eax, 0
    jg .x_right

.x_ok:
    jmp .end

.x_left:
    ;; ball.x = ball.r
    mov edx, DWORD [ball.r]
    mov [edi], edx
    jmp .end

.x_right:
    ;; ball.x = width - ball.r
    sub edx, DWORD [ball.r]
    mov [edi], edx
    jmp .end

.end:
    pop rbp
    ret

update_ball:
    push rbp
    mov rbp, rsp

    lea edi, [ball.x]  ;; &ball.x
    lea esi, [ball.dx] ;; &ball.dx
    mov edx, width     ;; width
    call update_ball_helper

    lea edi, [ball.y]
    lea esi, [ball.dy]
    mov edx, height
    call update_ball_helper

    pop rbp
    ret

main:
    push rbp
    mov rbp, rsp

    mov rdi, width
    mov rsi, height
    mov rdx, title
    call InitWindow

    mov rsi, fps
    call SetTargetFPS

.event_loop:
    call WindowShouldClose
    test rax, rax
    jnz .exit

    call BeginDrawing

    ;; int3
    ;; update
    call update_ball

    ;; draw
    call draw_background
    call draw_ball

    call EndDrawing

    jmp .event_loop

.exit:
    call CloseWindow

    pop rbp
    ret
