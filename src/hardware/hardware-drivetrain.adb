with AVR.MCU;

package body Hardware.DriveTrain is

   procedure Init is
   begin
      MCU.DDRB_Bits (Pin_Right) := DD_Output;
      MCU.DDRB_Bits (Pin_Left)  := DD_Output;

      PWM.Connect (Pin_Right, Motor_Right);
      PWM.Connect (Pin_Left, Motor_Left);

      PWM.Set (Motor_Right, Rotate_Stop);
      PWM.Set (Motor_Left,  Rotate_Stop);
   end Init;

   procedure Forward is
   begin
      PWM.Set (Motor_Right, Rotate_Backward);
      PWM.Set (Motor_Left,  Rotate_Forward);
   end Forward;

   procedure Backward is
   begin
      PWM.Set (Motor_Left,  Rotate_Backward);
      PWM.Set (Motor_Right, Rotate_Forward);
   end Backward;

   procedure Rotate_Left is
   begin
      PWM.Set (Motor_Left,  Rotate_Backward);
      PWM.Set (Motor_Right, Rotate_Backward);
   end Rotate_Left;

   procedure Rotate_Right is
   begin
      PWM.Set (Motor_Left,  Rotate_Forward);
      PWM.Set (Motor_Right, Rotate_Forward);
   end Rotate_Right;

   procedure Stop is
   begin
      PWM.Set (Motor_Left,  Rotate_Stop);
      PWM.Set (Motor_Right, Rotate_Stop);
   end Stop;

end Hardware.DriveTrain;
