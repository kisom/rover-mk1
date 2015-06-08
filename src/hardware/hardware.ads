--  Hardware contains the code to control the hardware platform. This
--  top level package contains initialisation for the hardware before any
--  of the specific modules are set up.
package Hardware is

   -- Init is required for any of other hardware modules.
   procedure Init;

end Hardware;
