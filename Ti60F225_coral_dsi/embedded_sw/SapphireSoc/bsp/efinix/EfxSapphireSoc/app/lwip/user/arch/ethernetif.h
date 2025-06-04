//HIHI ethernetif
#ifndef LWIP_ETHERNETIF_H
#define LWIP_ETHERNETIF_H


#include "lwip/err.h"
#include "lwip/netif.h"
#include "dmasg.h"

#define FRAME_PACKET  	256
#define BUFFER_SIZE 	1514

err_t ethernetif_init(struct netif *netif);
void  ethernetif_input(struct netif *netif);

int check_dma_status(int num_descriptor);
void flush_data_cache(void);

int cur_des;

#endif /* LWIP_ETHERNETIF_H */
