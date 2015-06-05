with Interfaces;
use  Interfaces;

package ROSA.Tasks is

   type States is (Running, Suspended, Waiting, Ready);
   type Task_Status is (OK,
      Not_Ready,
      Not_Running);
   type Tasking is private;

   --  Initialise a new tasking structure.
   procedure Create (Task_ID, Priority : in Unsigned_8; t : out Tasking);

   --  Start up a ready task, putting it into the running state.
   function Run (t : in Tasking) return Task_Status;

   --  Suspend a running task.
   function Suspend (t : in Tasking) return Task_Status;

private
   type Tasking is record
      Task_ID  : Unsigned_8;
      State    : States;
      Priority : Unsigned_8;
   end record;
end ROSA.Tasks;
