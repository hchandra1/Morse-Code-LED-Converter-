 # 🔦 Morse Code LED Converter  

This project is an embedded system program designed to **convert ASCII text into Morse code** and flash an LED to display the encoded message. Written in **RISC-V assembly language**, it demonstrates low-level programming skills and hardware control using GPIO (General Purpose Input/Output) pins.  

## 🚀 Project Overview  
The Morse Code Converter processes a string of characters, translates each into Morse code using a lookup table (LUT), and flashes a single LED to represent the encoded signal. This project bridges software and hardware by controlling LED behavior through GPIO registers, showcasing skills in embedded systems and assembly programming.  

## 🎯 Features  
- **ASCII to Morse Code Conversion** – Converts input text to Morse code using a LUT in assembly.  
- **LED Flashing** – Flashes an LED to represent Morse signals with a 500ms time base.  
- **Efficient Timing** – Implements precise delay subroutines to synchronize LED flashes with Morse code patterns.  
- **Hardware Control** – Direct manipulation of GPIO registers to enable and disable LED output.  

## 🛠️ Technologies Used  
- **Language:** Assembly (RISC-V)  
- **Hardware:** LED Bar, GPIO Pins, Seven-Segment LED Display  
- **Tools:** RISC-V Simulator, Hardware Testing Environment  

## 📂 Project Structure  
```
MorseCode-LED/
│
├── src/
│   ├── morsecode.S        # Main assembly program for Morse code conversion
│   └── utils.S        # Additional subroutines (LED control, delay functions)
│
├── data/
│   └── morse_lookup.txt  # Lookup table for Morse code patterns (A-Z)
│
├── Makefile           # Compilation instructions for the RISC-V toolchain
│
└── README.md          # Project documentation (this file)
```  

## ⚙️ How It Works  
1. **Initialization:**  
   - The GPIO base address is loaded, and all LED pins are enabled for output.  
   - The LED bar is reset to an off state before Morse code processing begins.  

2. **Character Processing:**  
   - Each ASCII character is processed by a subroutine (`CHAR2MORSE`) to obtain the Morse code equivalent from the LUT.  

3. **LED Control:**  
   - The LED flashes based on Morse patterns, with short flashes for dots and longer flashes for dashes.  
   - A delay subroutine (`DELAY`) manages the time between flashes to adhere to Morse code standards.  

4. **Looping:**  
   - After processing each character, the system loops through the input string until completion.  

---

## 🚦 Running the Project  
### 1. Clone the Repository:  
```bash
git clone <repo-link>
cd MorseCode-LED
```  

### 2. Compile the Project (Using RISC-V Toolchain):  
```bash
make
```  

### 3. Upload to the RISC-V Board (or Simulator):  
```bash
make upload
```  

---

## 📜 Example Data (ASCII Input)  
```text
AKHCO  
```  

The LED will flash in the Morse code patterns for "A", "K", "H", "C", and "O".  

---

## 🔩 Key Subroutines  
- **LED_ON:** Turns on the LED by setting GPIO output values.  
- **LED_OFF:** Turns off the LED by clearing the GPIO output.  
- **DELAY:** Creates an accurate 500ms delay loop for Morse timing.  
- **CHAR2MORSE:** Converts an ASCII character to Morse code by accessing the LUT.  

---

## 🎨 Why I Built This  
I wanted to explore how **low-level programming** and **hardware control** intersect in embedded systems. This project pushed me to understand GPIO manipulation, timing constraints, and the power of assembly language in controlling physical hardware.  

---

## 🚧 Future Improvements  
- **Multi-LED Support:** Flash different LEDs for each Morse code signal.  
- **Real-Time Input:** Accept real-time ASCII input via UART to convert and flash dynamically.  
- **Audio Output:** Generate audio beeps alongside LED flashes to simulate classic Morse transmissions.  

---

## 📝 License  
This project is open-source and available under the MIT License.  
