.global _start
_start:     la x1, target
            li x2, 0x13
            sw x2, 0(x1)
            sw x2, 4(x1)

            csrwi 0x7c9, 1

target:     j fail1
            j fail2
            j test2

fail1:      j fail1

fail2:      j fail2

test2:      li x1, 0
            li x2, 4
            li x3, 10
            li x4, 0
loop:       bne x1, x3, flag1
            addi x4, x4, 1
flag1:      bne x1, x3, flag2
            addi x4, x4, 1
flag2:      bne x1, x3, flag3
            addi x4, x4, 1
flag3:      addi x1, x1, 1
            bne x1, x2, nopurge
            csrwi 0x7c9, 1
nopurge:    bne x1, x3, loop

done:       j done
