BITS 64
section .text

;
; entry point, contains main loop
;
global _start
_start:
    mov   rdi, 1        ; stdout, we just leave this here as argument for sys_write syscall
    xor   bp, bp        ; counter = 0

loop_top:
    xor   r10d, r10d    ; Was fizz or buzz or both?

    mov   rsi, fizz     ; string = Fizz
    mov   r9d, 4        ; strlen = print first 4 characters
    mov   bl, 3         ; mod 3
    call  print_if_mod_eq

    mov   rsi, buzz     ; string = Buzz
    mov   r9d, 4        ; strlen
    mov   bl, 5         ; mod 5
    call  print_if_mod_eq

    ; if we printed nothing, print x
    test  r10d, r10d
    jnz    add_newline

    ; print x
    ; rax will still be 1(sys_write)
    ; rdi will still be 1(stdout)
    mov   rsi, x        ; str = "x"
    mov   rdx, 1        ; strlen = 1
    mov   rax, 1
    syscall

add_newline:
    
    ; print "\n"
    ; rax and rdi already set
    mov   rsi, nl       ; str = "\n"
    mov   dl, 1         ; strlen = 1
    mov   rax, 1
    syscall
    

    ; increase loop counter
    add   bp, 1
    cmp   bp, 100
    jnz  loop_top

    ; exit program, status code will be 1 for success
    mov   rax, 60       ; sys_exit
    syscall


fizz:
    db  "Fizz"
buzz:
    db  "Buzz"
x:
    db  "x"
nl:
    db  0x0a


; print the string in rsi of length r9d on stdout
; if the value in bp mod the value in bl is equal 0
print_if_mod_eq:
    mov   ax, bp          ; current value to ax
    div   bl              ; ah = ax % bl
    test  ah, ah          ; remainder
    jz    do_print
    ret

do_print:
    mov   edx, r9d        ; length
    mov   rax, 1
    syscall               ; rdi is fd, rsi is buffer

    mov   r10d, 1         ; save that it was fizz or buzz or both
    ret

