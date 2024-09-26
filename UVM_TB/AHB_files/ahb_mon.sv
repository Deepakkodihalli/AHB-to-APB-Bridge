class ahb_mon extends uvm_driver #(ahb_trans);

	`uvm_component_utils(ahb_mon);
	
	virtual ahb_interface.MON_MP vif;
	ahb_config h_cfg;
	
	uvm_analysis_port #(ahb_trans) h_port;
	
	extern function new(string name = "ahb_mon", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass

function ahb_mon:: new(string name = "ahb_mon", uvm_component parent);
	super.new(name,parent);
	h_port = new("h_port",this);
endfunction

function void ahb_mon:: build_phase(uvm_phase phase);

	super.build_phase(phase);
	if(!uvm_config_db #(ahb_config):: get(this,"","ahb_config",h_cfg))
		`uvm_fatal(get_type_name(),"unable to get() ahb_config from db");
endfunction

function void ahb_mon:: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	vif = h_cfg.vif ;
endfunction

task ahb_mon:: run_phase(uvm_phase phase);
	super.run_phase(phase);
	@(vif.mon_cb);
	@(vif.mon_cb);
	wait(vif.mon_cb.hready_out == 1)
	
	forever
	begin
		collect_data();
	end
endtask

task ahb_mon:: collect_data();
//	#10;
	ahb_trans xtn;
	xtn = ahb_trans::type_id::create("ahb_trans");
	
		
	
	//@(vif.mon_cb);
	
	wait(vif.mon_cb.hready_out == 1)
	@(vif.mon_cb);
	xtn.haddr = vif.mon_cb.haddr;
	xtn.htrans = vif.mon_cb.htrans;
	xtn.hsize = vif.mon_cb.hsize;
	xtn.hwrite = vif.mon_cb.hwrite;
	xtn.hready_in = vif.mon_cb.hready_in;
	xtn.hready_out = vif.mon_cb.hready_out;
	xtn.hresp = vif.mon_cb.hresp;
	
	repeat(2)
	@(vif.mon_cb);
	wait(vif.mon_cb.hready_out == 1)
	//@(vif.mon_cb);
	if(vif.mon_cb.hwrite)
		xtn.hwdata = vif.mon_cb.hwdata;
	else
		xtn.hrdata = vif.mon_cb.hrdata;
		
	`uvm_info(get_type_name(),$sformatf(" Printing from AHB_MON \n %s",xtn.sprint),UVM_LOW);
	
	h_port.write(xtn);
	
endtask
	
