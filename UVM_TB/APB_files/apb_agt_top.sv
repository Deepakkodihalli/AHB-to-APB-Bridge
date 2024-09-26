class apb_agt_top extends uvm_env;

    `uvm_component_utils(apb_agt_top);
	
	apb_agt p_agt;

    function new(string name = "apb_agt_top", uvm_component parent);
            super.new(name,parent);
    endfunction
		
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		p_agt = apb_agt::type_id::create("apb_agt",this);
	endfunction

endclass

