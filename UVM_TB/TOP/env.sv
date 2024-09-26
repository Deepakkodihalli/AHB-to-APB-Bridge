class env extends uvm_env;

	`uvm_component_utils(env);
	
	ahb_agt_top h_top;
	apb_agt_top p_top;
	env_config m_cfg;
	sb scr_brd;
	
	extern function new(string name = "env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass

function env:: new(string name = "env", uvm_component parent);
	super.new(name,parent);
endfunction

function void env:: build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db #(env_config):: get(this,"","env_config",m_cfg))
		`uvm_fatal(get_type_name(), "unable to get() env_config from db");
		
	if(m_cfg.has_ahb_agt)
	begin
		uvm_config_db #(ahb_config):: set(this,"*","ahb_config",m_cfg.h_cfg);
		h_top = ahb_agt_top::type_id:: create("ahb_agt_top",this);
	end
	
	if(m_cfg.has_apb_agt)
	begin
		uvm_config_db #(apb_config):: set(this,"*","apb_config",m_cfg.p_cfg);
		p_top = apb_agt_top::type_id:: create("apb_agt_top",this);

	end
	
	scr_brd = sb::type_id::create("scr_brd",this);
	
	
endfunction

function void env:: connect_phase(uvm_phase phase);

	if(m_cfg.has_ahb_agt)
		h_top.h_agt.h_mon.h_port.connect(scr_brd.fifo_ahb.analysis_export);
		
	if(m_cfg.has_apb_agt)
		p_top.p_agt.p_mon.p_port.connect(scr_brd.fifo_apb.analysis_export);
	
endfunction
	

task env:: run_phase(uvm_phase phase);

	uvm_top.print_topology();
endtask
		
	
