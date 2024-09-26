class apb_drv extends uvm_driver #(apb_trans);

	`uvm_component_utils(apb_drv);
	
	virtual apb_interface.DRV_MP vif;
	apb_config h_cfg;
	
	extern function new(string name = "apb_drv", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut();
endclass

function apb_drv:: new(string name = "apb_drv", uvm_component parent);
	super.new(name,parent);
endfunction

function void apb_drv:: build_phase(uvm_phase phase);

	super.build_phase(phase);
	if(!uvm_config_db #(apb_config):: get(this,"","apb_config",h_cfg))
		`uvm_fatal(get_type_name(),"unable to get() apb_config from db");
endfunction

function void apb_drv:: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	vif = h_cfg.vif ;
endfunction

task apb_drv:: run_phase(uvm_phase phase);
	super.run_phase(phase);
	
	@(vif.drv_cb);
	vif.drv_cb.presetn <= 1'b0;
	@(vif.drv_cb);
	vif.drv_cb.presetn <= 1'b1;
	
	forever
	begin
		send_to_dut();
	end
endtask

task apb_drv:: send_to_dut();
	
	wait(vif.drv_cb.pselx !== 0)
	
	repeat(2)
    @(vif.drv_cb);
	
	if(vif.drv_cb.pwrite == 0)
	begin
		wait(vif.drv_cb.penable == 1'b1)
		vif.drv_cb.prdata <= $urandom;	
	end
	repeat(2)
    @(vif.drv_cb);
	
endtask
	