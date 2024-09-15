
module mod_counter( input clk, reset, load, mode, [3:0] data_in, output reg [3:0] data_out);
	
	
	always @(posedge clk)
	begin	
		if(reset)
			begin
				data_out <= 4'b0;
			end
		else if (load)
			
			data_out <= data_in;
			if(mode == 0)
			begin
				if(data_out > 10) data_out <= 4'b0;
				
				else data_out = data_out +1'b1;
			end
			
			else if (mode == 1) 
			begin
				if ( data_out > 11 || data_out < 1)
					data_out <= 4'b0;
				else data_out <= data_out - 1'b1;
			end
	end		
				
endmodule
				
				
						
				
			
