#ifndef SLEEP_H
#define SLEEP_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

#include "stm32g431xx.h"
#include "stm32g4xx_hal_rcc.h"
#include "core_cm4.h"

uint32_t DWT_Delay_Init(void);
__STATIC_INLINE void DWT_Delay_ms(volatile uint32_t au32_milliseconds);


#ifdef __cplusplus
}  // extern "C"
#endif

#endif // SLEEP_H
