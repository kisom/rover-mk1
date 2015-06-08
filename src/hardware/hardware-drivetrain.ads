with AVR;          use AVR;
with Interfaces;   use Interfaces;
with Hardware.PWM; use Hardware;

package Hardware.DriveTrain is

   procedure Init;

   procedure Forward;
   procedure Backward;
   procedure Rotate_Left;
   procedure Rotate_Right;
   procedure Stop;

private
   Motor_Right : Hardware.PWM.Servo_Index;
   Motor_Left  : Hardware.PWM.Servo_Index;

   Pin_Right : AVR.Bit_Number := 3; --  PB5
   Pin_Left  : AVR.Bit_Number := 4; --  PB6

   Rotate_Forward  : Unsigned_16 := 1700;
   Rotate_Stop     : Unsigned_16 := 1500;
   Rotate_Backward : Unsigned_16 := 1300;
end Hardware.DriveTrain;
