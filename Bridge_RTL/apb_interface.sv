interface apb_interface(input bit clock);
	
	logic [31:0]paddr;
	logic [31:0]pwdata;
	logic [31:0]prdata;
	logic psel;
	logic presetn, penable,pwrite;
	
	clocking drv_cb @(posedge clock);
	
		input pwrite;
		input psel;
		input penable;
		output prdata;
	endclocking
	
	clocking mon_cb @(posedge clock);
		
		input paddr;
		input presetn;
		input pwdata;
		input pwrite;
		input psel;
		input penable;
		input prdata;
	endclocking
	
	modport DRV_MP(clocking drv_cb);
	modport MON_MP(clocking mon_cb);
	
endinterface
		