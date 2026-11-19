
-- another comment
with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
use Ada.Calendar;
use Ada.Text_IO;


procedure comm1 is

    subtype Item is Integer range 0 .. 20;
	package Random_Item is new Ada.Numerics.Discrete_Random (Item);
	use Random_Item;

    Message: constant String := "Process communication";
	task buffer is
            -- add your task entries for communication 
		entry Put (numi : in Item);
		entry Get (numo : out Item);
	end buffer;

	task producer is
            -- add your task entries for communication  
	end producer;

	task consumer is
            -- add your task entries for communication 
	end consumer;

	task body buffer is 
		Message: constant String := "buffer executing";
                -- change/add your local declarations here   
		B : array (0 .. 9) of Item;
		Count : Integer := 0;
		In_Index : Integer := 0;
		Out_Index : Integer := 0;
	begin
		Put_Line(Message);
		loop
                -- add your task code inside this loop    
		select
		    when Count < 10 =>
			accept Put(numi : in Item) do
			B(In_Index) := numi;
			end Put;
			Count := Count + 1;
			In_Index := (In_Index + 1) mod 10;

		or
		    when Count > 0 =>
			accept Get (numo : out Item) do
			numo := B(Out_Index);
			end Get;
			Count := Count - 1;
			Out_Index := (Out_Index + 1) mod 10;

		end select;
		end loop;
	end buffer;

	task body producer is 
		Message: constant String := "producer executing";
                -- change/add your local declarations here
		G : Generator;
		Num : Item;
	begin
		Put_Line(Message);
		Reset(G);
		loop
                -- add your task code inside this loop  
			Num := Random(G);
			buffer.Put (Num);
		end loop;
	end producer;

	task body consumer is 
		Message: constant String := "consumer executing";
                -- change/add your local declarations here
			Sum : Integer := 0;
			Num : item;
	begin
		Put_Line(Message);
		Main_Cycle:
		loop 
                -- add your task code inside this loop 
			buffer.Get (Num);
			Sum := Sum + Num;
			exit Main_Cycle when Sum > 100;
		end loop Main_Cycle; 

                -- add your code to stop executions of other tasks    
			abort buffer;
			abort producer; 
		Put_Line("Ending the consumer");

		exception
			  when TASKING_ERROR =>
				  Put_Line("Buffer finished before producer");
	end consumer;
begin
	Put_Line(Message);
end comm1;
