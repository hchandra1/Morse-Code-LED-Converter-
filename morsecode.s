.section .text
.align 2
.globl _start

_start:

// -------------------------------------------------------------------------------------
// GPIO Control Registers Memory Mapping
// -------------------------------------------------------------------------------------

.equ GPIO_BASE_CTRL_ADDR, 0x10012000 // Base address for GPIO control registers
.equ GPIO_OUTPUT_EN, 0x08            // Offset for enabling GPIO outputs
.equ GPIO_OUTPUT_VAL, 0x0C           // Offset for setting GPIO outputs
.equ GPIO_OUTPUT_XOR, 0x40           // Offset for XOR operation on GPIO outputs

// -------------------------------------------------------------------------------------
// LED Control Register Address Mapping
// -------------------------------------------------------------------------------------

.equ GPIO_7SEGLED_PINS, 0x0000023F   // GPIO pins for 7-segment LED display
.equ GPIO_LEDBAR_PINS, 0x00FC0C00    // GPIO pins for LED bar (8 LEDs)
.equ GPIO_ALL_LED_PINS, 0x00FC0E3F   // GPIO pins for all LEDs (15 total)
.equ GPIO_LEDBAR_LED_1, 0x00000800   // GPIO pin for LEDBAR LED1
.equ GPIO_LEDBAR_LED_7, 0x00800000   // GPIO pin for LEDBAR LED7

// -------------------------------------------------------------------------------------
// GPIO Control Registers Initialization
// -------------------------------------------------------------------------------------

li t0, GPIO_BASE_CTRL_ADDR           // Load GPIO base address
li t1, GPIO_ALL_LED_PINS             // Load value to enable all GPIO pins for LEDs
sw t1, GPIO_OUTPUT_EN(t0)            // Enable outputs on all GPIO LED Pins
li t2, 0xFF03F1C0
sw t2, GPIO_OUTPUT_VAL(t0)           // Set all LED pins to zero (turn off all LEDs)

// Reset s1 to the starting address of the input string
ResetLUT:
la s1, InputLUT                      // Assign s1 to start address of the input string

// Process each character in the input string
NextChar:
lbu a0, 0(s1)                        // Load a character from the input string
addi s1, s1, 1                       // Move to the next character in the string
snez a1, a0                          // Check if end of the string is reached
bnez a1, ProcessChar                 // If not, process the character

li a2, 4
jal ra, DELAY                        // Delay for 4 dots before restarting message
j ResetLUT                           // Restart the message

// Display the converted character to LED BAR LED_7
// Authors: Ayesh Kadike, Hari Chandrasekhar
// Date: October 7, 2024
// Subroutines and Parameter Passing

ProcessChar:
jal ra, CHAR2MORSE
li t0, 0x80000000                    // Load most significant bit
li t3, 0x0                           // Initialize shift count
jal LED_OFF

trim:
and t1, t0, a1                       // Mask the most significant bit
bnez t1, displayValues               // Begin displaying values when all trailing zeros are trimmed
addi t3, t3, 0x1                     // Increment shift count for trimming zeros
slli a1, a1, 0x1                     // Shift left to check next bit
j trim

displayValues:
and t1, t0, a1                       // Check most significant bit
bnez t1, ledon                       // If bit is 1, turn on LED
jal LED_OFF                          // If bit is 0, turn off LED
j loop2

ledon:
jal LED_ON                           // Turn on LED if bit is 1

loop2:
li a2, 1
jal DELAY                            // Delay for 500ms (1 dot duration)
slli a1, a1, 0x1                     // Shift left for next bit
addi t3, t3, 0x1                     // Increment shift count
li t4, 0x20
blt t3, t4, displayValues            // Repeat until all bits are displayed
jal LED_OFF
li a2, 3
jal DELAY                            // Delay for 1.5 seconds (3 dots) between characters
j NextChar

// Turn the LED On
LED_ON:
addi sp, sp, -16
sw ra, 12(sp)
sw s0, 0(sp)
sw s1, 4(sp)
sw s2, 8(sp)

li s0, GPIO_BASE_CTRL_ADDR           // Load GPIO base address
li s1, GPIO_LEDBAR_LED_7             // Load LED_7 address (bit 11)
lw s2, GPIO_OUTPUT_VAL(s0)           // Read current GPIO output values
or s2, s1, s2                        // Set LED_7 bit
sw s2, GPIO_OUTPUT_VAL(s0)           // Update GPIO output values

lw s0, 0(sp)
lw s1, 4(sp)
lw s2, 8(sp)
lw ra, 12(sp)
addi sp, sp, 16
ret

// Turn the LED Off
LED_OFF:
addi sp, sp, -16
sw ra, 12(sp)
sw s0, 0(sp)
sw s1, 4(sp)
sw s2, 8(sp)

li s0, GPIO_BASE_CTRL_ADDR           // Load GPIO base address
li s1, GPIO_LEDBAR_LED_7             // Load LED_7 address (bit 11)
xori s1, s1, 0xFFFFFFFF              // Invert LED_7 bit
lw s2, GPIO_OUTPUT_VAL(s0)           // Read current GPIO output values
and s2, s1, s2                       // Clear LED_7 bit
sw s2, GPIO_OUTPUT_VAL(s0)           // Update GPIO output values

lw s0, 0(sp)
lw s1, 4(sp)
lw s2, 8(sp)
lw ra, 12(sp)
addi sp, sp, 16
ret

// Delay Subroutine
DELAY:
addi sp, sp, -8
sw s0, 0(sp)
sw s1, 4(sp)

li s0, 0x3d0900                      // Load countdown value for 500ms
mul s0, s0, a2                       // Multiply by delay factor

loop1:
addi s0, s0, -1
bne s0, x0, loop1                    // Decrement until zero

lw s0, 0(sp)
lw s1, 4(sp)
addi sp, sp, 8
ret

// Convert ASCII character to Morse code pattern
// Input: ASCII character in a0, output Morse pattern in a1

CHAR2MORSE:
addi sp, sp, -16                     // Set up the stack frame
sw ra, 12(sp)                        // Save return address
sw s0, 0(sp)                         // Save s0 to the stack
addi s0, a0, -0x41                   // Calculate index from 'A'
slli s0, s0, 0x1                     // Multiply index by 2 to get byte offset
la t1, MorseLUT                      // Load address of Morse lookup table
add t1, t1, s0                       // Calculate address in lookup table
lhu a1, 0(t1)                        // Load Morse pattern for character
lw s0, 0(sp)                         // Restore s0 value
lw ra, 12(sp)                        // Restore return address
addi sp, sp, 16                      // Restore stack
ret

// Data Section
.align 2

// Input string to be converted
InputLUT:
.asciz "AKHCO"                       // Input string to convert (Example: "AKHCO")

// Morse Code Lookup Table for A-Z
.align 2
MorseLUT:
.half 0x17, 0x1D5, 0x75D, 0x75       // Morse patterns for A, B, C, D
.half 0x1, 0x15D, 0x1DD, 0x55        // Morse patterns for E, F, G, H
.half 0x5, 0x1777, 0x1D7, 0x175      // Morse patterns for I, J, K, L
.half 0x77, 0x1D, 0x777, 0x5DD       // Morse patterns for M, N, O, P
.half 0x1DD7, 0x5D, 0x15, 0x7        // Morse patterns for Q, R, S, T
.half 0x57, 0x157, 0x177, 0x757      // Morse patterns for U, V, W, X
.half 0x1D77, 0x775                  // Morse patterns for Y, Z

End:
.end