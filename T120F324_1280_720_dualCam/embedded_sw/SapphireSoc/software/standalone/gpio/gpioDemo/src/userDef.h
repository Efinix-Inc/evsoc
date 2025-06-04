#include "soc.h"

#ifdef SYSTEM_GPIO_0_IO_CTRL
    #define GPIO0   SYSTEM_GPIO_0_IO_CTRL
#else
    #error "GPIO is disabled, please enable it in IP Manager!!!"
#endif
#ifdef SIM
    #define LOOP_UDELAY 100
#else
    #define LOOP_UDELAY 100000
#endif

