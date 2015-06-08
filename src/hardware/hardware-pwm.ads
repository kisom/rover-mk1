with AVR, AVR.MCU;   use AVR;
with Interfaces;
use  Interfaces;

package Hardware.PWM is

   --  Set Servo_ISR as the TIMER1 COMPA handler. See page 101 of the
   --  ATmega2560 datasheet for more details.
   procedure Servo_ISR;
   pragma Machine_Attribute (Entity => Servo_ISR,
                             Attribute_Name => "interrupt");

   pragma Export (C, Servo_ISR, MCU.Sig_Timer1_COMPA_String);
   Max_Servos : constant := 4;  --  Board has 4 PWM connectors.
   type Servo_Index is range 1 .. Max_Servos;

   procedure Connect (pin : in AVR.Bit_Number; which : out Servo_Index);
   procedure Trim (which : in Servo_Index; trim : in Integer_16);
   procedure Set (which : in Servo_Index; us : in Unsigned_16);

private
   Duty_Cycle      : constant := 20000; --  20ms pulse width
   Update_Interval : constant := 40000;
   Update_Wait     : constant := 5;     --  Allow for minor interrupt delays.

   --  Specified in the servo datasheet and common to this hardware
   --  configuration.
   Min_Pulse : constant := 1300;
   Mid_Pulse : constant := 1500;
   Max_Pulse : constant := 1700;

   type Servo is
   record
      Pin   : AVR.Bit_Number;
      Ticks : Unsigned_16;
      Min   : Unsigned_16;
      Max   : Unsigned_16;
      Trim  : Integer_16;
   end record;
   type Servo_ptr is access Servo;

   Servos : array (1 .. Max_Servos) of Servo_ptr;

   --  0 is used to indicate the refresh cycle has completed.
   Active_Servos   : Integer range 0 .. Max_Servos := 0;
   Current_Servo   : Integer range 0 .. Max_Servos := 1;

end Hardware.PWM;
