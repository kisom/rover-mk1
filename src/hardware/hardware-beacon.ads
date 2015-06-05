with AVR; use AVR;
with AVR.MCU;
with Interfaces;


package Hardware.Beacon is

   -- Tick_Size indicates how many ticks in a 100ms beacon cycle there are.
   procedure Init (Tick_Size : in Interfaces.Unsigned_8);
   procedure Trigger;

private
   LED1_Bit   : Bit_Number := 4;
   LED2_Bit   : Bit_Number := 5;
   LED1       : Boolean renames MCU.PORTH_Bits (LED1_Bit);
   LED2       : Boolean renames MCU.PORTH_Bits (LED2_Bit);
   Tick       : Interfaces.Unsigned_8;
   Counter    : Interfaces.Unsigned_8;
   Resolution : Interfaces.Unsigned_8;
end Hardware.Beacon;
