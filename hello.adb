with Ada.Real_Time;
with Ada.Text_IO;

procedure Hello is
   use Ada.Real_Time;

   Start_Time : constant Time := Clock;

   procedure Print_Execution (Name : String) is
      Elapsed : constant Duration := To_Duration (Clock - Start_Time);
   begin
      Ada.Text_IO.Put_Line
        (Name & " executing at time" & Duration'Image (Elapsed) & " s");
      Ada.Text_IO.Flush;
   end Print_Execution;

   procedure F1 is
   begin
      Print_Execution ("F1");
   end F1;

   procedure F2 is
   begin
      Print_Execution ("F2");
   end F2;

   procedure F3 is
   begin
      Print_Execution ("F3");
   end F3;

   procedure Scheduler
     (Run_F1, Run_F2, Run_F3 : not null access procedure)
   is
      task F1_F2_Task;
      task F3_Task;

      task body F1_F2_Task is
         Next_Start : Time := Start_Time;
      begin
         loop
            delay until Next_Start;
            Run_F1.all;
            Run_F2.all;
            --  Anchor each release to the schedule to avoid accumulating drift.
            Next_Start := Next_Start + Seconds (1);
         end loop;
      end F1_F2_Task;

      task body F3_Task is
         Next_Start : Time := Start_Time + Milliseconds (500);
      begin
         loop
            delay until Next_Start;
            Run_F3.all;
            Next_Start := Next_Start + Seconds (2);
         end loop;
      end F3_Task;
   begin
      null; --  Scheduler waits here for its tasks, which run until interrupted.
   end Scheduler;
begin
   Scheduler (F1'Access, F2'Access, F3'Access);
end Hello;
