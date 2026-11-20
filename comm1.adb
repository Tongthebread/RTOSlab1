--Process commnication: Ada lab part 3

with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
use Ada.Calendar;
use Ada.Text_IO;

procedure comm1 is
   -- only allow integers from 0 to 20 to make sure random numbers stay in this range.
   subtype Item is Integer range 0 .. 20;
   -- creat a random number generator that only produces values in the range of 0 to 20.
	package Random_Item is new Ada.Numerics.Discrete_Random (Item);
	use Random_Item;

    Message: constant String := "Process communication";
   -- define an active task buffer as a bounded FIFO buffer
   -- which will be called by producer and consumer.
	task buffer is
            -- add your task entries for communication 
      -- called by the producer to insert an item into the buffer.
		entry Put (numi : in Item);
      --called by the consumer to take an item from the buffer.
		entry Get (numo : out Item);
	end buffer;

	task producer is
   -- add your task entries for communication  
   -- no entry needed because producer only calls buffer and dont need to be called by other tasks.
	end producer;

	task consumer is
   -- add your task entries for communication
   -- no entry needed because consumer only calls buffer and dont need to be called by other tasks. 
	end consumer;

	task body buffer is 
		Message: constant String := "buffer executing";
                -- change/add your local declarations here   
      -- circular buffer of size 10 to store items in FIFO order.
		B : array (0 .. 9) of Item;
      -- count how many items are in the buffer right now.
		Count : Integer := 0;
      -- next position to write a item into the buffer.
		In_Index : Integer := 0;
      -- next position to read the oldest item.
		Out_Index : Integer := 0;
	begin
		Put_Line(Message);
		loop
      -- add your task code inside this loop  
      -- use select to choose between put and get based on whether the buffer not full or not empty.  
		select
         -- put a item into the buffer when the buffer is not full.
		    when Count < 10 =>
			accept Put(numi : in Item) do
			B(In_Index) := numi;
			end Put;
         -- update count and the index after put.
         -- since this is a circular buffer we have to set the index back to 0 after reaching 9.
			Count := Count + 1;
			In_Index := (In_Index + 1) mod 10;

		or
         -- give an item to consumer when the buffer is not empty.
		    when Count > 0 =>
			accept Get (numo : out Item) do
			numo := B(Out_Index);
			end Get;
         -- update the count and index.
			Count := Count - 1;
			Out_Index := (Out_Index + 1) mod 10;

		end select;
		end loop;
	end buffer;

	task body producer is 
		Message: constant String := "producer executing";
      -- change/add your local declarations here
      -- random number generator state.
		G : Generator;
      -- hold the random number befor insert to the buffer.
		Num : Item;
	begin
		Put_Line(Message);
		Reset(G);
		loop
      -- add your task code inside this loop  
      -- generate random numbers from 0 to 20 and sending them to the buffer.
			Num := Random(G);
			buffer.Put (Num);
		end loop;
	end producer;

	task body consumer is 
		Message: constant String := "consumer executing";
         -- change/add your local declarations here
         -- running total of all received numbers.
			Sum : Integer := 0;
         -- hold the number that taken from the buffer.
			Num : item;
	begin
		Put_Line(Message);
		Main_Cycle:
		loop 
         -- add your task code inside this loop 
         -- take an item from the buffer and add it to the total.
			buffer.Get (Num);
			Sum := Sum + Num;
         -- stop once the total is more than 100.
			exit Main_Cycle when Sum > 100;
		end loop Main_Cycle; 

         -- add your code to stop executions of other tasks
         -- stop other two tasks since they are running in the infinite loop.    
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
