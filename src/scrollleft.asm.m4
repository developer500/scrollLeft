define(`ev', 0)

define(`LD_DE_HL', `ld   d,h
    ld   e,l')

define(`CONV_16', `cp  8
    jr  c, format(`e%d', ev)
    ld  b, a
    ld  a, $`'8F
    sub b
format(`.e%d', ev)
    define(`ev', incr(ev))
    scf
    ccf')

define(`CONV_16_AND_ROTATE', `CONV_16
    $1
    and $2')

define(`FOR_B',`ld  b, $1
$2:
    push bc')

define(`NEXT_B',`pop bc
    djnz $1')

define(ADD_REG,
    `define(`li', $2)
     ifelse(eval(li),0,,
        `inc $1`'ADD_REG(`$1',decr(li))')')


INCLUDE "defs.asm"

;------------------------------------------------------------
; code starts here and gets added to the end of the REM
;------------------------------------------------------------
EXTERN testdisplay

scrollleft:

    call testdisplay

    ; the scroll repeats col * 2 times to clear the screen
    FOR_B(n_columns*2, loop1)

        ld   hl,(d_file)

        inc  hl

        LD_DE_HL

        inc  hl        ; hl points to 1 ahead of de

        ; repeat the scroll n_rows - 2 times.
        FOR_B(n_rows - 2 , loop2)

            FOR_B(n_columns - 1 , loop3)

                ld   a, (hl)

                ; the byte ahead
                CONV_16_AND_ROTATE(rla, $0A)

                ld   c, a

                ld   a, (de)

                CONV_16_AND_ROTATE(rra, $05)

                ; This is the key instruction - or the current char with the one ahead.
                or   c

                ; convert the combined value back to a zx81 block char
                CONV_16

                ; and save it back to the display.
                ld (de), a

                inc de
                inc hl

            NEXT_B(loop3)

            ld  a, (de)

            ; The last column on the right
            CONV_16_AND_ROTATE(rra, $05)

            CONV_16
            ld     (de), a

            ADD_REG(`hl', 2)
            ADD_REG(`de', 2)

        NEXT_B(loop2)

    NEXT_B(loop1)

    ret