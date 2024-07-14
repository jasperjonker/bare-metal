#include "gpio.h"

int main(void) {
  // Turn GPIOPB8 LD2 (green LED) on
  gpio_set_mode(PIN('B', 8), OUTPUT);
  gpio_write(PIN('B', 8), 1);

  while (1) ; // Infinite loop

  return 0; // Do nothing so far
}

// Startup code
__attribute__((naked, noreturn)) void _reset(void) {
  // memset .bss to zero, and copy .data section to RAM region
  extern long _sbss, _ebss, _sdata, _edata, _sidata;
  for (long *dst = &_sbss; dst < &_ebss; dst++) *dst = 0;
  for (long *dst = &_sdata, *src = &_sidata; dst < &_edata;) *dst++ = *src++;

  main();             // Call main()
  for (;;) (void) 0;  // Infinite loop in the case if main() returns
}

extern void _estack(void);  // Defined in link.ld

// 16 standard and 102 STM32-specific handlers
__attribute__((section(".vectors"))) void (*const tab[16 + 102])(void) = {
  _estack, _reset
};

