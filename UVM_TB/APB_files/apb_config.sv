class apb_config extends uvm_object;

	`uvm_object_utils(apb_config);
	
	uvm_active_passive_enum is_active ;
	virtual apb_interface vif;
	
	static int data_sent;
	static int data_rcvd;
	
	function new(string name = "apb_config");
		super.new(name);
	endfunction	
endclass
