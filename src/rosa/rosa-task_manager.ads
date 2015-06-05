with Interfaces;
use  Interfaces;

eackage ROSA.Task_Manager is
   type Manager_Type is private;

private
   type Manager_Type is record
      Task_Count : Unsigned_8;
   end record;

   Manager : Manager_Type;
end ROSA.Task_Manager;
