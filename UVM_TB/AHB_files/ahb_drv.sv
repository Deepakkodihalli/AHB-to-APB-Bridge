class ahb_drv extends uvm_driver #(ahb_trans);

	`uvm_component_utils(ahb_drv);
	
	virtual ahb_interface.DRV_MP vif;
	ahb_config h_cfg;
	
	extern function new(string name = "ahb_drv", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(ahb_trans xtn);
endclass

function ahb_drv:: new(string name = "ahb_drv", uvm_component parent);
	super.new(name,parent);
endfunction

function void ahb_drv:: build_phase(uvm_phase phase);

	super.build_phase(phase);
	if(!uvm_config_db #(ahb_config):: get(this,"","ahb_config",h_cfg))
		`uvm_fatal(get_type_name(),"unable to get() ahb_config from db");
endfunction

function void ahb_drv:: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	vif = h_cfg.vif ;
endfunction

task ahb_drv:: run_phase(uvm_phase phase);
	super.run_phase(phase);
	
	@(vif.drv_cb);
	vif.drv_cb.hresetn <= 1'b0;
	@(vif.drv_cb);
	vif.drv_cb.hresetn <= 1'b1;
	
	forever
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done;
	end
endtask

task ahb_drv:: send_to_dut(ahb_trans xtn);
	
	`uvm_info(get_type_name(),$sformatf("printing from AHB_DRV \n %s",xtn.sprint),UVM_LOW);
	
	//wait(vif.drv_cb.hready_out == 1'b1)
	vif.drv_cb.haddr <= xtn.haddr;
	vif.drv_cb.htrans <= xtn.htrans;
	vif.drv_cb.hwrite <= xtn.hwrite;
	vif.drv_cb.hsize <= xtn.hsize;
	vif.drv_cb.hready_in <= 1'b1;
	
	repeat(2)
	@(vif.drv_cb);
	
	wait(vif.drv_cb.hready_out == 1'b1)
	if(xtn.hwrite)
	vif.drv_cb.hwdata <= xtn.hwdata;
	else
	vif.drv_cb.hwdata <= 32'b0;
	
	@(vif.drv_cb);
	
endtask
	