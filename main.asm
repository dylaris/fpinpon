format ELF64 executable

include "constant.inc"
include "syscall.inc"

segment readable writeable

hello: db "Hello, World", 10, 0
hello_len = $ - hello - 1

segment readable executable

entry _start

_start:
    write STDOUT_FILENO, hello, hello_len
    exit 69
