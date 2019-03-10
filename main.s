.syntax unified

.word 0x20000100
.word _start

.global _start
.type _start, %function
_start:
	movs r0,#1
    movs r1,#2
    movs r2,#3

    push {r0,r1,r2}

    pop {r3,r4,r5}

    movs r3,#0
    movs r4,#0
    movs r5,#0
    
    push {r2,r0,r1}

    pop {r1,r2,r0}
    
    
    
	//
	//branch w/o link
	//

    b	label01

label01:

	//
	//branch w/ link
	//
	bl	sleep

sleep:
	nop
	b	.
