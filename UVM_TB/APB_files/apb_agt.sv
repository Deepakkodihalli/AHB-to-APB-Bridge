class apb_agt extends uvm_agent;

	`uvm_component_utils(apb_agt);
	
	apb_config p_cfg;
	apb_drv p_drv;
	apb_mon p_mon;
	apb_seqr p_seqr;
	
	extern function new(string name = "apb_agt", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

function apb_agt:: new(string name = "apb_agt", uvm_component parent);
		super.new(name,parent);
endfunction

function void apb_agt:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(apb_config):: get(this,"","apb_config",p_cfg))
		`uvm_fatal(get_type_name(),"cannot get() apb_config from db");
		
	p_mon = apb_mon::type_id::create("apb_mon",this);
	
	if(p_cfg.is_active)
	begin
		p_drv = apb_drv::type_id::create("apb_drv",this);
		p_seqr = apb_seqr::type_id::create("apb_seqr",this);
	end
	
endfunction

function void apb_agt:: connect_phase(uvm_phase phase);

	super.connect_phase(phase);
	
	if(p_cfg.is_active)
		p_drv.seq_item_port.connect(p_seqr.seq_item_export);
		
endfunction
	