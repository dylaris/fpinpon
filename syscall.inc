;;
;; syscall numbers
;;

SYS_write equ 1
SYS_exit  equ 60

;;
;; syscall general macros
;;

macro syscall1 nr, arg {
    mov rax, nr
    mov rdi, arg
    syscall
}

macro syscall2 nr, arg1, arg2 {
    mov rax, nr
    mov rdi, arg1
    mov rsi, arg2
    syscall
}

macro syscall3 nr, arg1, arg2, arg3 {
    mov rax, nr
    mov rdi, arg1
    mov rsi, arg2
    mov rdx, arg3
    syscall
}

;;
;; syscall specific macros
;;

macro write fd, buf, count {
    syscall3 SYS_write, fd, buf, count
}

macro exit code {
    syscall1 SYS_exit, code
}

