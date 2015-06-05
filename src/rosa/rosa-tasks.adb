package body ROSA.Tasks is

   procedure Create (Task_ID, Priority : in Unsigned_8; t : out Tasking) is
   begin
      t.Task_ID := Task_ID;
      t.Priority := Priority;
      t.State := Waiting;
   end Create;

   function Run (t : in Tasking) return Task_Status is
   begin
      if t.State /= Ready then
         return Not_Ready;
      end if;

      --  Fill this in later.
      return OK;
   end Run;

   function Suspend (t : in Tasking) return Task_Status is
   begin
      if t.State /= Running then
         return Not_Running;
      end if;

      --  Fill this in later.
      return OK;
   end Suspend;

end ROSA.Tasks;
