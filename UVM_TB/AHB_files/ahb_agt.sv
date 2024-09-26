class ahb_agt extends uvm_agent;

	`uvm_component_utils(ahb_agt);
	
	ahb_config h_cfg;
	ahb_drv h_drv;
	ahb_mon h_mon;
	ahb_seqr h_seqr;
	
	extern function new(string name = "ahb_agt", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

function ahb_agt:: new(string name = "ahb_agt", uvm_component parent);
		super.new(name,parent);
endfunction

function void ahb_agt:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(ahb_config):: get(this,"","ahb_config",h_cfg))
		`uvm_fatal(get_type_name(),"cannot get() ahb_config from db");
		
	h_mon = ahb_mon::type_id::create("ahb_mon",this);
	
	if(h_cfg.is_active)
	begin
		h_drv = ahb_drv::type_id::create("ahb_drv",this);
		h_seqr = ahb_seqr::type_id::create("ahb_seqr",this);
	end
	
endfunction

function void ahb_agt:: connect_phase(uvm_phase phase);

	super.connect_phase(phase);
	
	if(h_cfg.is_active)
		h_drv.seq_item_port.connect(h_seqr.seq_item_export);
		
endfunction
	