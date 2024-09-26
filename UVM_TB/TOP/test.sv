class base_test extends uvm_test;
	
	`uvm_component_utils(base_test);
	
	env envh;
	env_config m_cfg;
	ahb_config h_cfg;
	apb_config p_cfg;
	
    int has_ahb_agt = 1;
	int has_apb_agt = 1;
	
	extern function new (string name = "base_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void config_agt();
endclass

function base_test:: new (string name = "base_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void base_test:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	m_cfg = env_config::type_id:: create("m_cfg");
	
	if(has_ahb_agt)
		h_cfg = ahb_config:: type_id:: create("ahb_cfg");
		
	if(has_apb_agt)
		p_cfg = apb_config::type_id::create("apb_cfg");

	config_agt();
		
	envh = env::type_id::create("envh",this);
endfunction

function void base_test:: config_agt();

	if(has_ahb_agt)
	begin
		if(!uvm_config_db #(virtual ahb_interface):: get(this,"","ahb_interface", h_cfg.vif))
			`uvm_fatal(get_type_name(), "unable to get() vif from db");
			
		h_cfg.is_active = UVM_ACTIVE;
		m_cfg.h_cfg = h_cfg;
		m_cfg.has_ahb_agt = has_ahb_agt;

	end
	
	if(has_apb_agt)
	begin
		if(!uvm_config_db #(virtual apb_interface):: get(this,"","apb_interface", p_cfg.vif))
			`uvm_fatal(get_type_name(), "unable to get() vif from db");
			
		p_cfg.is_active = UVM_ACTIVE;
		m_cfg.p_cfg = p_cfg;
		m_cfg.has_apb_agt = has_apb_agt;
	end
	
	uvm_config_db #(env_config):: set(this,"*", "env_config", m_cfg);
	
endfunction

class single_test extends base_test;

	`uvm_component_utils(single_test);
	
	single_seqs ss_h;
	
	function new(string name = "single_test", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		
		ss_h = single_seqs::type_id::create("single_seqs");
		
		ss_h.start(envh.h_top.h_agt.h_seqr);
		#60;
		phase.drop_objection(this);
		
	endtask
	
endclass

class inc_trf_test extends base_test;

	`uvm_component_utils(inc_trf_test);
	
	inc_trf_seqs inc_h;
	
	function new(string name = "inc_trf_test", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		
		inc_h = inc_trf_seqs::type_id::create("inc_trf_seqs");
		
		inc_h.start(envh.h_top.h_agt.h_seqr);
		#72;
		phase.drop_objection(this);
		
	endtask
	
endclass

class wrap_trf_test extends base_test;

	`uvm_component_utils(wrap_trf_test);
	
	wrap_trf_seqs wrap_h;
	
	function new(string name = "wrap_trf_test", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		
		wrap_h = wrap_trf_seqs::type_id::create("wrap_trf_seqs");
		
		wrap_h.start(envh.h_top.h_agt.h_seqr);
		#60;
		phase.drop_objection(this);
		
	endtask
	
endclass
		
	
	
	
