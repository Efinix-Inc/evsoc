#ifndef BOARD_CONFIG_H
#define BOARD_CONFIG_H

/* Auto-generated for T120F576 - 640_480 */
/* Do not edit manually. Re-generate using script. */

/* Board identity */
#define BOARD_T120F576

/* Feature flags */
#define HAS_HDMI
#define HAS_MIPI_RST

/* Resolution */
#define FRAME_WIDTH  640
#define FRAME_HEIGHT 480

/* Memory addresses */
//Start address to be divided evenly by 8. Otherwise DMA tkeep might be shifted, not handled in display block.
#define DISPLAY_START_ADDR    0x01000000

//User data location in flash (non-volatile)
#define FLASH_START_ADDR      0x003B0000

#endif /* BOARD_CONFIG_H */
