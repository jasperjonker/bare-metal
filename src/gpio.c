#include "gpio.h"
#include "stm32g431xx.h"

struct gpio {
    volatile uint32_t MODER, OTYPER, OSPEEDR, PUPDR, IDR, ODR, BSRR, LCKR, AFR[2];
};

// Bank A to G
extern void gpio_enable_bank(uint8_t bank, bool en) {
  RCC->AHB2ENR |= (en << (bank - 'A'));
 }

extern void gpio_set_mode(uint16_t pin, uint8_t mode) {
  struct gpio *gpio = GPIO(PINBANK(pin)); // GPIO bank
  uint8_t n = PINNO(pin);                 // Pin number
  gpio->MODER &= ~(3U << (n * 2));        // Clear existing setting
  gpio->MODER |= (mode & 3) << (n * 2);   // Set new mode

  if (mode == OUTPUT) {
    gpio->OTYPER |= (0U << pin);            // Push-pull
    gpio->OSPEEDR |= (0b11 << (n * 2));     // Very High speed
  }
}

extern void gpio_write(uint16_t pin, bool val) {
  struct gpio *gpio = GPIO(PINBANK(pin));
  gpio->BSRR = (1U << PINNO(pin)) << (val ? 0 : 16);
}
