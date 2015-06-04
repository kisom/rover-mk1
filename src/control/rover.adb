with AVR;
use  AVR;

with Interfaces;
use  Interfaces;

with AVR.MCU;             -- port and pin definitions.
with AVR.Real_Time.Clock; -- required for delay to work.
pragma Unreferenced (AVR.Real_Time.Clock);
with AVR.Timer1;

procedure Rover is

   LED1        : Boolean renames MCU.PORTH_Bits (5); -- digital pin 8
   LED2        : Boolean renames MCU.PORTH_Bits (4); -- digital pin 7

begin

   MCU.DDRH_Bits :=  (others => DD_Output);
   MCU.DDRH_Bits (4) := DD_Output;
   MCU.DDRH_Bits (5) := DD_Output;

   loop
      LED1 := High;
      delay(0.1);
      LED1 := Low;
      LED2 := High;
      delay(0.1);
      LED2 := Low;
      delay(0.8);
   end loop;

end Rover;
