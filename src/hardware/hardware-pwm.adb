with AVR.Interrupts;

package body Hardware.PWM is

   procedure Connect (pin : in AVR.Bit_Number; which : out Servo_Index) is
      s : Servo_ptr;
   begin
      if (Active_Servos < Max_Servos) then
         Active_Servos := Active_Servos + 1;
         Servos (Active_Servos) := new Servo;
         s := Servos(Active_Servos);

         s.Pin   := pin;
         s.Min   := Min_Pulse;
         s.Max   := Max_Pulse;
         s.Trim  := 0;
         s.Ticks := 0;
         which := Servo_Index (Active_Servos);
      end if;
   end Connect;

   procedure Trim (which : in Servo_Index ; trim : in Integer_16) is
      s : Servo_ptr;

      --  We use Servo_Index for constraint checks, but need to use the
      --  Integer value for compatibility elsewhere.
      n : Integer;
   begin
      n := Integer (which);
      if (Active_Servos > 0 and n < Active_Servos) then
         s := Servos (n);
         s.Trim := trim;
      end if;
   end Trim;

   function ServoMaxPulse (s : Servo_ptr) return Unsigned_16 is
   begin
      return Max_Pulse - Update_Wait * s.Max;
   end ServoMaxPulse;

   function ServoMinPulse (s : Servo_ptr) return Unsigned_16 is
   begin
      return Max_Pulse - Update_Wait * s.Min;
   end ServoMinPulse;

   procedure Set (which : in Servo_Index; us : in Unsigned_16) is
      n     : Integer;
      s     : Servo_ptr;
      dur   : Unsigned_16;
      sSREG : Unsigned_8;
   begin
      n := Integer (which);
      if (n < Active_Servos) then
         s := Servos (n);

         dur := us + Unsigned_16 (s.Trim);
         if (us < ServoMinPulse (s)) then
            dur := ServoMinPulse (s);
         elsif (us > ServoMaxPulse (s)) then
            dur := ServoMaxPulse (s);
         end if;

         sSREG := MCU.SREG;
         Interrupts.cli;

         s.Ticks := dur;

         MCU.SREG := sSREG;
         Interrupts.sei;
      end if;
   end Set;

   procedure Servo_ISR is
      s : Servo_ptr;
   begin
      if (Current_Servo < Active_Servos and Current_Servo /= 0) then
         s := Servos (Current_Servo);
         MCU.PORTB_Bits (s.Pin) := Low;
      else
         MCU.TCNT1 := 0;
         Current_Servo := 0;
      end if;

      Current_Servo := Current_Servo + 1;
      if (Current_Servo < Active_Servos) then
         s := Servos (Current_Servo);
         MCU.OCR1A := MCU.TCNT1 + s.Ticks;
         MCU.PORTB_Bits (s.Pin) := High;
      else
         if ((MCU.TCNT1 + Update_Wait) < Update_Interval) then
            MCU.OCR1A := Update_Interval;
         else
            MCU.OCR1A := MCU.OCR1A + Update_Wait;
         end if;
      end if;
   end Servo_ISR;

end Hardware.PWM;
