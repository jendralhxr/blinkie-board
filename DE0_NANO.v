// ============================================================================
// Copyright (c) 2011 by Terasic Technologies Inc. 
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// ============================================================================
// Major Functions/Design Description:
//
//   Please refer to DE0_Nano_User_manual.pdf in DE0_Nano system CD.
//
// ============================================================================
// Revision History:
// ============================================================================
//   Ver.: |Author:   |Mod. Date:    |Changes Made:
//   V1.0  |EricChen  |02/01/2011    |
// ============================================================================

//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module DE0_NANO(

	//////////// CLOCK //////////
	CLOCK_50,

	//////////// LED //////////
	LED,

	//////////// KEY //////////
	KEY,

	//////////// SW //////////
	SW,

	//////////// SDRAM //////////
	DRAM_ADDR,
	DRAM_BA,
	DRAM_CAS_N,
	DRAM_CKE,
	DRAM_CLK,
	DRAM_CS_N,
	DRAM_DQ,
	DRAM_DQM,
	DRAM_RAS_N,
	DRAM_WE_N,

	//////////// EPCS //////////
	EPCS_ASDO,
	EPCS_DATA0,
	EPCS_DCLK,
	EPCS_NCSO,

	//////////// Accelerometer and EEPROM //////////
	G_SENSOR_CS_N,
	G_SENSOR_INT,
	I2C_SCLK,
	I2C_SDAT,

	//////////// ADC //////////
	ADC_CS_N,
	ADC_SADDR,
	ADC_SCLK,
	ADC_SDAT,

	//////////// 2x13 GPIO Header //////////
	GPIO_2,
	GPIO_2_IN,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	GPIO_0_D,
	GPIO_0_IN,

	//////////// GPIO_0, GPIO_1 connect to GPIO Default //////////
	GPIO_1_D,
	GPIO_1_IN,

);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input 		          		CLOCK_50;

//////////// LED //////////
output		     [7:0]		LED;

//////////// KEY //////////
input 		     [1:0]		KEY;

//////////// SW //////////
input 		     [3:0]		SW;

//////////// SDRAM //////////
output		    [12:0]		DRAM_ADDR;
output		     [1:0]		DRAM_BA;
output		          		DRAM_CAS_N;
output		          		DRAM_CKE;
output		          		DRAM_CLK;
output		          		DRAM_CS_N;
inout 		    [15:0]		DRAM_DQ;
output		     [1:0]		DRAM_DQM;
output		          		DRAM_RAS_N;
output		          		DRAM_WE_N;

//////////// EPCS //////////
output		          		EPCS_ASDO;
input 		          		EPCS_DATA0;
output		          		EPCS_DCLK;
output		          		EPCS_NCSO;

//////////// Accelerometer and EEPROM //////////
output		          		G_SENSOR_CS_N;
input 		          		G_SENSOR_INT;
output		          		I2C_SCLK;
inout 		          		I2C_SDAT;

//////////// ADC //////////
output		          		ADC_CS_N;
output		          		ADC_SADDR;
output		          		ADC_SCLK;
input 		          		ADC_SDAT;

//////////// 2x13 GPIO Header //////////
inout 		    [12:0]		GPIO_2;
input 		     [2:0]		GPIO_2_IN;

//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
inout 		    [33:0]		GPIO_0_D;
input 		     [1:0]		GPIO_0_IN;

//////////// GPIO_0, GPIO_1 connect to GPIO Default //////////
inout 		    [33:0]		GPIO_1_D;
//input 		    [33:0]		GPIO_1_D;
input 		     [1:0]		GPIO_1_IN;


//=======================================================
//  REG/WIRE declarations
//=======================================================
wire           				reset_n;
wire 							set_n;
reg [33:0] GPIO_1_D;
reg iseng;
reg [31:0] counter;
reg [31:0] overflow;
reg [7:0] LED;
reg [7:0] temp;
reg [7:0] data;
reg phase; // 0=off 1='emit' data
reg phase_led;

initial begin
	overflow <= 25100;
end
						
//=======================================================
//  Structural coding
//=======================================================

assign   reset_n = KEY[0];
assign   set_n = KEY[1];

always @(posedge CLOCK_50 or negedge reset_n or negedge set_n)
	begin
		if(!reset_n)
			begin
				overflow <= 25150;
				counter <= 0;
				LED[0] = 0;
				LED[1] = ~0;
				LED[2] = 0;
				LED[3] = ~0;
				LED[4] = 0; 
				LED[5] = ~0;
				LED[6] = 0;
				LED[7] = ~0;
				
			end
		else if(!set_n)
			begin	
				overflow <= 25200;
				counter <= 0;
				LED[0] = ~0;
				LED[1] = ~0; 
				LED[2] = ~0;
				LED[3] = ~0;
				LED[4] = ~0;
				LED[5] = ~0;
				LED[6] = ~0;
				LED[7] = ~0;
				end
		else begin
			counter   <= counter+1;
			//GPIO_1_D[9]<= CLOCK_50;
			if (counter>100) phase<= 0;
			else phase <= 1;
			GPIO_1_D[25] <= phase;
			//GPIO0_1_D[9] <= counter[14];
				if (counter>overflow) 
				begin
					if (phase_led) phase_led<=0;
					else phase_led <= ~0;
					counter <= 0;
					data <= data+1;
					// lit the LEDs
					if (data[0]) LED[0] <= ~0;
					else LED[0] <= 0;
					if (data[1]) LED[1] <= ~0;
					else LED[1] <= 0;
					if (data[2]) LED[2] <= ~0;
					else LED[2] <= 0;
					if (data[3]) LED[3] <= ~0;
					else LED[3] <= 0;
					if (data[4]) LED[4] <= ~0;
					else LED[4] <= 0;
					if (data[5]) LED[5] <= ~0;
					else LED[5] <= 0;
					if (data[6]) LED[6] <= ~0;
					else LED[6] <= 0;
					if (phase_led) LED[7]<=~0;
					else LED[7]=0;
					
				end // counter overflow
			end // counter add
		end // always
endmodule
