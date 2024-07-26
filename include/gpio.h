#ifndef GPIO_H
#define GPIO_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

/* The GPIO(bank) upper byte indicates GPIO bank, and lower byte indicates pin number*/
#define GPIO(bank) ((struct gpio *) (0x48000000 + 0x400 * (bank)))
#define PIN(bank, num) ((((bank) - 'A') << 8) | (num))
#define PINNO(pin) (pin & 255U)
#define PINBANK(pin) (pin >> 8U)


enum gpio_mode {
    INPUT = 0b00,
    OUTPUT = 0b01,
    ALTERNATE = 0b10,
    ANALOG = 0b11
};

extern void gpio_enable_bank(uint8_t bank, bool en);
extern void gpio_set_mode(uint16_t pin, uint8_t mode);
extern void gpio_write(uint16_t pin, bool val);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif // GPIO_H
