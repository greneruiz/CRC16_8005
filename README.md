 Version/Date : V1.0 / 2025-JAN-31 / G.RUIZ
	* Initial release
  * This is a CRC16 calculator with generics for bit ordering. Polynomial = 0x8005, start value = 0x0000.
    Method of Operation:
      1. Assert I_INIT for 1 CLK cycle; this will reset the start polynomial to 0x0000.
      2. Feed in the data 1 byte at a time; Assert I_ENA_PULSE for 1 CLK cycle for each input byte.
      3. O_CRC_VALUE becomes available after 13 CLK cycles. Proceed to feed in the next data.
    Note: Input Data is NOT latched inside the component; be careful not to modify its value during the 13 CLKs
