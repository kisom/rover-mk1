pragma Profile (Ravenscar);

with AVR;
use  AVR;
with AVR.Serial, AVR.Wait;

with Hardware, Hardware.Beacon, Hardware.DriveTrain;

with Hardware.PWM;
pragma Unreferenced (Hardware.PWM);

procedure Rover is

   ticks : Integer := 0;

   procedure Wait_1ms is new Wait.Generic_Wait_Usecs (16_000_000, 1000);

begin

   Hardware.Init;
   Hardware.DriveTrain.Init;
   Hardware.Beacon.Init (100);

   Serial.Init (Serial.Baud_9600_16MHz);
   Serial.Put ("BOOT OK");
   Serial.CRLF;

   Hardware.DriveTrain.Forward;

   loop
      Wait_1ms;
      Hardware.Beacon.Trigger;
      ticks := ticks + 1;
      if (ticks > 3000) then
         Hardware.DriveTrain.Stop;
         loop
            null;
         end loop;
      end if;
   end loop;

end Rover;
