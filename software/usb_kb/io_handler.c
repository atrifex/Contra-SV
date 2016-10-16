//io_handler.c
#include "io_handler.h"
#include <stdio.h>
#include "alt_types.h"
#include "system.h"

#define otg_hpi_address		(volatile int*) 	OTG_HPI_ADDRESS_BASE		// OTG_HPI_ADDRESS_BASE and others are defined in the other include file
#define otg_hpi_data		(volatile int*)	    OTG_HPI_DATA_BASE			// We are taking those defined values and placing them in this file
#define otg_hpi_r			(volatile char*)	OTG_HPI_R_BASE				// Then we are type casting them to be type pointer.
#define otg_hpi_cs			(volatile char*)	OTG_HPI_CS_BASE 			// FOR SOME REASON CS BASE BEHAVES WEIRDLY MIGHT HAVE TO SET MANUALLY
#define otg_hpi_w			(volatile char*)	OTG_HPI_W_BASE


void IO_init(void)
{
	*otg_hpi_cs = 1;
	*otg_hpi_r = 1;
	*otg_hpi_w = 1;
	*otg_hpi_address = 0;
	*otg_hpi_data = 0;
}



/*
 * The singles need to be set as such because we are not working in a purely procedural domain.
 * To do something, we have to take into account the order in wich events occur
 *
 */


void IO_write(alt_u8 Address, alt_u16 Data)
{
//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//


	*otg_hpi_r = 1;					// makes sure we are not reading

	*otg_hpi_address = Address;		// initializes address and data
	*otg_hpi_data = Data;

	*otg_hpi_cs = 0;				// enables chip
	*otg_hpi_w = 0;					// write to address

	*otg_hpi_w = 1;					// disables write functionality
	*otg_hpi_cs = 1;				// disables chip
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

	*otg_hpi_w = 1;					// makes sure we are not writing

	*otg_hpi_address = Address;		// initializes address to be read from

	*otg_hpi_cs = 0;				// enables chip
	*otg_hpi_r = 0;					// reads from address

	temp = *otg_hpi_data;

	*otg_hpi_r = 1;					// disables read functionality
	*otg_hpi_cs = 1;				// disables chip

	return temp;
}
