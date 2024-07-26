#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

#include "gpio.h"
#include "stm32g4xx_hal_pwr.h"
#include "stm32g4xx_hal_flash.h"
#include "stm32g4xx_hal.h"

#define LD2_Pin GPIO_PIN_8
#define LD2_GPIO_Port GPIOB

void Error_Handler(void);
void SystemClock_Config(void);


#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */
