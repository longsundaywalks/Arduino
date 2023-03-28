; Definitions
#define __SFR_OFFSET 0

; Include libraries or other header files
#include "avr/io.h"

; Expose these global functions
.global setup ; Used in place of setup() c function
.global loop  ; Used in place of loop() c function

; Pin definitions for traffic lights
#define RED_PIN 7 ; pin 13 (These are for NS traffic light flow.)
#define YELLOW_PIN 6 ; pin 12
#define GREEN_PIN 5 ; pin 11
#define RED_PIN2 4 ; pin 10 (These are for EW traffic light flow.)
#define YELLOW_PIN2 3 ; pin 50
#define GREEN_PIN2 2; pin 51
#define GREEN_PIN3 1; pin 52 (This is for NS pedestrian light flow.)
#define GREEN_PIN4 0; pin 53 (This is for EW pedestrian light flow.)

; Assembly version of setup() function
setup:
    ; Set pin directions for the red, yellow, and green lights (this is for the first direction)
    sbi DDRB, RED_PIN
    sbi DDRB, YELLOW_PIN
    sbi DDRB, GREEN_PIN
    
    ; Set pin directions for the red, yellow, and green lgiht (this is for the other direction)
    sbi DDRB, RED_PIN2
    sbi DDRB, YELLOW_PIN2
    sbi DDRB, GREEN_PIN2

    ; Set pin directions for the pedestrian lights.
    sbi DDRB, GREEN_PIN3
    sbi DDRB, GREEN_PIN4

    ; Initialize all lights to off
    cbi PORTB, RED_PIN
    cbi PORTB, YELLOW_PIN
    cbi PORTB, GREEN_PIN
    cbi PORTB, RED_PIN2
    cbi PORTB, YELLOW_PIN2
    cbi PORTB, GREEN_PIN2
    cbi PORTB, GREEN_PIN3
    cbi PORTB, GREEN_PIN4

    ; Return from setup
    ret
    
; Assembly version of loop() function
loop:
    ; Turn on North-South green light and East-West red light for 10 seconds
    cbi PORTB, GREEN_PIN4
    cbi PORTB, YELLOW_PIN
    cbi PORTB, YELLOW_PIN2
    sbi PORTB, GREEN_PIN
    sbi PORTB, RED_PIN2
    sbi PORTB, GREEN_PIN3
    call delay_10s
    ; Turn on both sets of yellow lights, and flash pedestrian light. This takes 2 seconds
    cbi PORTB, GREEN_PIN
    cbi PORTB, RED_PIN2
    sbi PORTB, YELLOW_PIN
    sbi PORTB, YELLOW_PIN2
    cbi PORTB, GREEN_PIN3
    call delay_1s
    sbi PORTB, GREEN_PIN3
    call delay_1s
    cbi PORTB, GREEN_PIN3
    call delay_1s
    sbi PORTB, GREEN_PIN3
    call delay_1s
    cbi PORTB, GREEN_PIN3
    call delay_1s
    
    ; Traffic lights East-West are green light and North-South are red light. 10 seconds.
    cbi PORTB, GREEN_PIN3
    cbi PORTB, YELLOW_PIN
    cbi PORTB, YELLOW_PIN2
    sbi PORTB, GREEN_PIN4
    sbi PORTB, GREEN_PIN2
    sbi PORTB, RED_PIN
    call delay_10s
    cbi PORTB, GREEN_PIN2
    cbi PORTB, RED_PIN
    sbi PORTB, YELLOW_PIN
    sbi PORTB, YELLOW_PIN2
    cbi PORTB, GREEN_PIN4
    call delay_1s
    sbi PORTB, GREEN_PIN4
    call delay_1s
    cbi PORTB, GREEN_PIN4
    call delay_1s
    sbi PORTB, GREEN_PIN4
    call delay_1s
    cbi PORTB, GREEN_PIN4
    call delay_1s

    ; Repeat the loop
    rjmp loop


; Function to delay for 1 second.
delay_1s:
          push r24              ; Store register 24 value on stack
          push r25              ; Store register 25 value on stack
          push r26              ; Store register 26 value on stack
          push r27              ; Store register 27 value on stack
          ldi  r24,10           ; Load 10 into register 24
delay_100ms:
          ldi  r25,100          ; Load 100 into register 25
delay_1ms:
          ldi  r27,4010 >> 8    ; Load high byte of value 4010 into reg 27
          ldi  r26,4010 & 255   ; Load low byte of value 4010 into reg 26
delay_ms:
          sbiw r26,1            ; Decrement ms count (r27:r26)
          brne delay_ms         ; loop to delay_ms while > 0
          dec  r25              ; Decrement register 25 by 1
          brne delay_1ms        ; loop for 100 us
          dec  r24              ; decrement register 24 by one
          brne delay_100ms      ; loop for 100 us
          pop  r27              ; Restore value r27 from stack
          pop  r26              ; Restore value r26 from stack
          pop  r25              ; Restore value r25 from stack
          pop  r24              ; Restore value r24 from stack
          ret                   ; return from subroutine

; Function to delay for 10 seconds
delay_10s:
    delay_10s:
          push r24              ; Store register 24 value on stack
          push r25              ; Store register 25 value on stack
          push r26              ; Store register 26 value on stack
          push r27              ; Store register 27 value on stack
          ldi  r24,10           ; Load 10 into register 24
    delay_1s_loop:
          rcall delay_1s        ; Call 1 second delay
          dec  r24              ; Decrement register 24 by one
          brne delay_1s_loop    ; loop for 1 second delay while > 0
          pop  r27              ; Restore value r27 from stack
          pop  r26              ; Restore value r26 from stack
          pop  r25              ; Restore value r25 from stack
          pop  r24              ; Restore value r24 from stack
    ret                   ; return from subroutine

    
