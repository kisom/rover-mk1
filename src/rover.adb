pragma Profile (Ravenscar);

with AVR;
use  AVR;

with Hardware.DriveTrain;
with Hardware.Beacon;
use  Hardware;

with AVR.Serial;
-- with Interfaces;
-- use  Interfaces;

with AVR.Wait;

procedure Rover is

   procedure Wait_1ms is new Wait.Generic_Wait_Usecs (16_000_000, 1000);

begin

   DriveTrain.Init;
   Beacon.Init (100);
   Serial.Init (Serial.Baud_9600_16MHz);
   Serial.Put ("BOOT OK");
   Serial.CRLF;

   Serial.Put ("INIT DRIVETRAIN");
   Serial.CRLF;

   Serial.Put ("FORWARD");
   Serial.CRLF;
   DriveTrain.Forward;


   loop
      Beacon.Trigger;
      Wait_1ms;
   end loop;

end Rover;
