--Cyclic scheduler with a watchdog: 

with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Float_Random;

use Ada.Calendar;
use Ada.Text_IO;
use Ada.Numerics.Float_Random;

-- add packages to use randam number generator


procedure cyclic_wd is
    Message: constant String := "Cyclic scheduler with watchdog";
        -- change/add your declarations here
        d: Duration := 1.0;
        s: Integer := 0;
	Start_Time: Time := Clock;
   Next_Time: Time := Start_Time;
        

	procedure f1 is 
		Message: constant String := "f1 executing, time is now";
	begin
		Put(Message);
		Put_Line(Duration'Image(Clock - Start_Time));
	end f1;

	procedure f2 is 
		Message: constant String := "f2 executing, time is now";
	begin
		Put(Message);
		Put_Line(Duration'Image(Clock - Start_Time));
	end f2;

	procedure f3 is 
		Message: constant String := "f3 executing, time is now";
      G : Generator;
	begin
		Put(Message);
		Put_Line(Duration'Image(Clock - Start_Time));
      Reset(G);
		-- add a random delay here
      if Random(G) > 0.5 then
      delay 1.0;
      end if;
	end f3;
	
	task Watchdog is
	       -- add your task entries for communication
          entry Start_Timer;
          entry Stop_Timer; 	
	end Watchdog;

	task body Watchdog is
		begin
		loop
         accept Start_Timer;        -- add your task code inside this loop
         select
         accept Stop_Timer;
         or
         delay 0.5;
         Put_Line("[Watchdog] Warning: F3 mised deadline!");
         accept Stop_Timer;
         end select; 
		end loop;
	end Watchdog;

	begin

        loop
            -- change/add your code inside this loop     
              f1;
              f2;
              if s mod 2 = 0 then
              delay until Next_Time + 0.5;
              Watchdog.Start_Timer;
              f3;
              Watchdog.Stop_Timer;
              end if;
              s := s + 1;
              Next_Time := Next_Time + d;
              while Next_Time < Clock loop
               Next_Time := Next_Time + d;
              end loop;
              delay until Next_Time;       
        end loop;
end cyclic_wd;

