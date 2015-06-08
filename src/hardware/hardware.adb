with AVR, AVR.MCU, AVR.Interrupts;
use  AVR, AVR.MCU;


package body Hardware is

   procedure Init_Timer1 is
   begin
      --  Enable Timer1 in the power-save register.
      PRR0_Bits (PRTIM1_Bit) := High;

      --  Normal WGM with prescaler of 8.
      TCCR1A_Bits := (others => False);
      TCCR1B_Bits := (CS11_Bit => True, others => False);

      TCNT1 := 0;                         --  Clear timer counter.
      TIFR1_Bits (OCF1A_Bit) := High;     --  Clear pending interrupts.
      TIMSK1_Bits (OCIE1A_Bit) := High;   --  Enable output/compare interrupt.
   end Init_Timer1;

   procedure Init_Timer3 is
   begin
      --  Enable Timer3 in the power-save register.
      PRR1_Bits (PRTIM3_Bit) := High;

      --  Fast WGM with prescaler of 8.
      TCCR3A_Bits := (others => False);
      TCCR3B_Bits := (CS11_Bit => True, others => False);

      TCNT3 := 0;                         --  Clear timer counter.
      TIFR3_Bits (OCF3A_Bit) := High;     --  Clear pending interrupts.
      TIMSK3_Bits (OCIE3A_Bit) := High;   --  Enable output/compare interrupt.
   end Init_Timer3;

   procedure Init is
   begin
      Init_Timer1;
      Init_Timer3;
      Interrupts.sei;
   end Init;

end Hardware;
