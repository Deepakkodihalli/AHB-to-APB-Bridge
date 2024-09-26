class env_config extends uvm_object;
	`uvm_object_utils(env_config);
	
	bit has_ahb_agt ;
	bit has_apb_agt ;
	
	ahb_config h_cfg;
	apb_config p_cfg;
	
	function new(string name = "env_config");
		super.new(name);
	endfunction
	
endclass