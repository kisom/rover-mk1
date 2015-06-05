with AVR; use AVR;
with AVR.MCU;

with Interfaces; use Interfaces;

package body Hardware.Beacon is
   procedure Init (Tick_Size : Interfaces.Unsigned_8) is
   begin
      Resolution := Tick_Size;
      MCU.DDRH_Bits (LED1_Bit) := DD_Output;
      MCU.DDRH_Bits (LED2_Bit) := DD_Output;

      LED1 := Low;
      LED2 := Low;

      Tick := 0;
      Counter := 0;
   end Init;

   procedure Trigger is
   begin
      if Tick >= Resolution then
         if Counter = 0 then
            LED1 := High;
            LED2 := High;
            Counter := Counter + 1;
         elsif Counter = 1 then
            LED1 := Low;
            LED2 := Low;
            Counter := Counter + 1;
         elsif Counter = 10 then
            Counter := 0;
         else
            Counter := Counter + 1;
         end if;
         Tick :=  0;
      else
         Tick := Tick + 1;
      end if;
   end Trigger;


end Hardware.Beacon;
