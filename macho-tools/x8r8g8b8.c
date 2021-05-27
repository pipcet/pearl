#include <stdint.h>
#include "snippet.h"

START_SNIPPET {
  *(volatile uint32_t *)0x230850030 = 0x5000;
} END_SNIPPET
