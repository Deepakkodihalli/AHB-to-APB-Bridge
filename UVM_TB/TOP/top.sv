module top;
	import uvm_pkg::*;
	import pkg::*;
	
	bit clock;
	always #5 clock = ~clock;
	
	 ahb_interface h_vif(clock);
	 apb_interface p_vif(clock);
	 
	rtl_top dut( .Hclk(clock),
				  .Hresetn(h_vif.hresetn),
				  .Htrans(h_vif.htrans),
				  .Hsize(h_vif.hsize),
				  .Hreadyin(h_vif.hready_in),
				  .Hwdata(h_vif.hwdata),
				  .Haddr(h_vif.haddr),
				  .Hwrite(h_vif.hwrite),
				  .Hrdata(h_vif.hrdata),
				  .Hresp(h_vif.hresp),
				  .Hreadyout(h_vif.hready_out),
				  
				  .Prdata(p_vif.prdata),
				  .Pselx(p_vif.pselx),
				  .Pwrite(p_vif.pwrite),
				  .Penable(p_vif.penable),
				  .Paddr(p_vif.paddr),
				  .Pwdata(p_vif.pwdata));
	initial
		begin
			`ifdef VCS
                     $fsdbDumpvars(0, top);
                      `endif			
			uvm_config_db #(virtual ahb_interface):: set(null,"*","ahb_interface",h_vif);
			uvm_config_db #(virtual apb_interface):: set(null,"*","apb_interface",p_vif);
			run_test("base_test");
			
		end
		
endmodule
