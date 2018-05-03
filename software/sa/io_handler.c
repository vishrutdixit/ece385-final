//io_handler.c
#include "io_handler.h"
#include "usb.h"
#include <stdio.h>


void IO_init(void)
{
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
	*otg_hpi_r = 1;
	*otg_hpi_w = 1;
	*otg_hpi_address = 0;
	*otg_hpi_data = 0;
	// Reset OTG chip
	*otg_hpi_cs = 0;
	*otg_hpi_reset = 0;
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
}

void IO_write(alt_u8 Address, alt_u16 Data)
{
//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//

//	volatile int* write_location = otg_hpi_address + Address;
//	*write_location = Data;
	// set access values
	*otg_hpi_address = Address;
	*otg_hpi_data = Data;

	// stage signal values, active low
	*otg_hpi_cs = 0;
	*otg_hpi_w = 0;

	// unstage signal values
	*otg_hpi_w = 1;
	*otg_hpi_cs = 1;
}

alt_u16 IO_read(alt_u8 Address)
{
	alt_u16 temp;
//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//
	//printf("%x\n",temp);
//	volatile int* read_location = otg_hpi_data + Address;
//	temp = *read_location;

	// set access values
	*otg_hpi_address = Address;

	// stage signal values, active low

	*otg_hpi_cs = 0;
	*otg_hpi_r = 0;

	temp = *otg_hpi_data;

	// unstage signal values
	*otg_hpi_r = 1;
	*otg_hpi_cs = 1;
	return temp;
}
