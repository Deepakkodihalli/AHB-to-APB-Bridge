class ahb_agt_top extends uvm_env;

	`uvm_component_utils(ahb_agt_top);
	
	ahb_agt h_agt;

	function new(string name = "ahb_agt_top", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		h_agt = ahb_agt::type_id::create("ahb_agt",this);
	endfunction

endclass
