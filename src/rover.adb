with AVR;
use  AVR;

with ROSA, ROSA.Tasks;
use  ROSA;

with AVR.MCU;             -- port and pin definitions.
with AVR.Real_Time.Clock; -- required for delay to work.
pragma Unreferenced (AVR.Real_Time.Clock);

procedure Rover is

   LED1        : Boolean renames MCU.PORTH_Bits (5); -- digital pin 8
   LED2        : Boolean renames MCU.PORTH_Bits (4); -- digital pin 7
   LED_Task    : Tasks.Tasking;

begin

   MCU.DDRH_Bits :=  (others => DD_Output);
   MCU.DDRH_Bits (4) := DD_Output;
   MCU.DDRH_Bits (5) := DD_Output;

   LED_Task := Tasks.Create (1, 2);

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
