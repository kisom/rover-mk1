with AVR, AVR.MCU;
use  AVR;

with Interfaces;
use  Interfaces;

package Hardware.DriveTrain is

   procedure Init;

   procedure Forward;
   procedure Backward;
   procedure RotateLeft;
   procedure RotateRight;
   procedure Stop;
   procedure Set (Left, Right : Interfaces.Unsigned_16);

private
   Left_Bit  : Bit_Number := 4;
   Right_Bit : Bit_Number := 3;

   --  Left and right motors; see the hardware documentation for
   --  more information.
   Left_Pin  : Boolean renames MCU.PORTB_Bits (Left_Bit);
   Right_Pin : Boolean renames MCU.PORTB_Bits (Right_Bit);

   Left_PWM  : Unsigned_16 renames MCU.OCR1B;
   Right_PWM : Unsigned_16 renames MCU.OCR1A;

   --  PWM pulse values for the various settings on the servo.
   Rotate_Forward  : constant := 16#b2#;
   Rotate_Stop     : constant := 16#b2#;
   Rotate_Backward : constant := 16#b2#;
end Hardware.DriveTrain;
