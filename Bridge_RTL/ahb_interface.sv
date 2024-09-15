interface ahb_interface(input bit clock);
	
	logic [31:0]haddr;
	logic [31:0]hwdata;
	logic [31:0]hrdata;
	logic [1:0] htrans;
	logic [2:0] hsize;
	logic [2:0] hburst;
	logic [1:0] hresp;
	logic hresetn, hwrite,hready_out, hready_in;
	
	clocking drv_cb @(posedge clock);
		
		output haddr;
		output hburst;
		output hrdata;
		output hresetn;
		output hsize;
		output htrans;
		output hwdata;
		output hwrite;
		input hready_out;
	endclocking
	
	clocking mon_cb @(posedge clock);
		
		input haddr;
		input hburst;
		input hrdata;
		input hresetn;
		input hsize;
		input htrans;
		input hwdata;
		input hwrite;
		input hresp;
		input hready_out;
		input hready_in;
	endclocking
	
	modport DRV_MP(clocking drv_cb);
	modport MON_MP(clocking mon_cb);
	
endinterface
		