--Protected types: Ada lab part 4

with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
use Ada.Calendar;
use Ada.Text_IO;

procedure comm2 is
    Message: constant String := "Protected Object";
    	type BufferArray is array (0 .. 9) of Integer;
        -- protected object declaration
      subtype Item is Integer range  0 .. 20;
      package Random_Item is new Ada.Numerics.Discrete_Random(Item);
      use Random_Item;

	protected  buffer is
            -- add entries of protected object here 
      entry Put (numi : in Item);
      entry Get (numo : out Item);

	private
            -- add local declarations
      B : BufferArray;
      Count : Integer := 0;
      In_Index : Integer := 0;
      Out_Index : Integer := 0;

	end buffer;

	task producer is
		-- add task entries
	end producer;

	task consumer is
                -- add task entries
	end consumer;

	protected body buffer is 
              -- add definitions of protected entries here 

      entry Put (numi : in Item) when Count < 10 is
      begin
            B (In_Index) := numi;
            Count := Count + 1;
            In_Index := (In_Index + 1) mod 10;
      end Put;

      entry Get(numo : out Item) when Count > 0 is
      begin
            numo := B (Out_Index);
            Count := Count - 1;
            Out_Index := (Out_Index + 1) mod 10;
      end Get;
	end buffer;

        task body producer is 
		Message: constant String := "producer executing";
                -- add local declrations of task here  
      Num : Item;
      G : Generator;
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
                -- add local declrations of task here 
      Sum : Integer := 0;
      Num : Item;
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
      abort producer;
		Put_Line("Ending the consumer");
	end consumer;

begin
Put_Line(Message);
end comm2;
