class apb_mon extends uvm_driver #(apb_trans);

	`uvm_component_utils(apb_mon);
	
	virtual apb_interface.MON_MP vif;
	apb_config h_cfg;
	
	uvm_analysis_port #(apb_trans) p_port;
	
	extern function new(string name = "apb_mon", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass

function apb_mon:: new(string name = "apb_mon", uvm_component parent);
	super.new(name,parent);
	p_port = new("p_port", this);
endfunction

function void apb_mon:: build_phase(uvm_phase phase);

	super.build_phase(phase);
	if(!uvm_config_db #(apb_config):: get(this,"","apb_config",h_cfg))
		`uvm_fatal(get_type_name(),"unable to get() apb_config from db");
endfunction

function void apb_mon:: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	vif = h_cfg.vif ;
endfunction

task apb_mon:: run_phase(uvm_phase phase);
	super.run_phase(phase);
	
	forever
	begin
		collect_data();
	end
endtask

task apb_mon:: collect_data();
	
	apb_trans xtn;
	xtn = apb_trans::type_id::create("apb_trans");
	
//	@(vif.mon_cb);
	wait(vif.mon_cb.penable == 1)
	 
	xtn.paddr = vif.mon_cb.paddr;
	xtn.pwrite = vif.mon_cb.pwrite;
	xtn.pselx = vif.mon_cb.pselx;
	xtn.penable = vif.mon_cb.penable;
	
	@(vif.mon_cb);
	
	if(vif.mon_cb.pwrite)
		xtn.pwdata = vif.mon_cb.pwdata;
	else
		xtn.prdata = vif.mon_cb.prdata;
		
	repeat(2)
	@(vif.mon_cb);
		
	`uvm_info(get_type_name(),$sformatf(" Printing from APB_MON \n %s",xtn.sprint),UVM_LOW);
	
	p_port.write(xtn);
	
endtask
	
