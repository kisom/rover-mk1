with AVR, AVR.MCU, AVR.Real_Time.Clock, AVR.Timer1;
use  AVR;

pragma Unreferenced (AVR.Timer1);
pragma Unreferenced (AVR.Real_Time.Clock);

with Interfaces;

package body Hardware.DriveTrain is

   procedure Init is
   begin

      --  Enable Timer1 by setting its power reduction mode to off.
      MCU.PRR1_Bits (MCU.PRTIM1_Bit) := Low;

      Timer1.Init_PWM (Timer1.Scale_By_8, Timer1.Fast_PWM_8bit, False);
      MCU.DDRB_Bits (Left_Bit) := DD_Output;
      MCU.DDRB_Bits (Right_Bit) := DD_Output;

      Stop;
   end Init;

   procedure Forward is
   begin
      Left_PWM := MCU.ICR1 - Rotate_Backward;
      Right_PWM := MCU.ICR1 - Rotate_Forward;
   end Forward;

   procedure Stop is
   begin
      Left_PWM := Rotate_Stop;
      Right_PWM := Rotate_Stop;
   end Stop;

   procedure Backward is
   begin
      Left_PWM := Rotate_Forward;
      Right_PWM := Rotate_Backward;
   end Backward;

   procedure RotateLeft is
   begin
      Left_PWM := Rotate_Backward;
      Right_PWM := Rotate_Backward;
   end RotateLeft;

   procedure RotateRight is
   begin
      Left_PWM := Rotate_Forward;
      Right_PWM := Rotate_Forward;
   end RotateRight;

   procedure Set (Left, Right : Interfaces.Unsigned_16) is
   begin
      Left_PWM := Left;
      Right_PWM := Right;
   end Set;

end Hardware.DriveTrain;
