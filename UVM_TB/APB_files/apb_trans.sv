class apb_trans extends uvm_sequence_item ;

	`uvm_object_utils(apb_trans);
	
     bit [31:0]paddr;
	 bit [31:0]pwdata;
	 rand bit [31:0]prdata;
	 bit penable;
	 bit [3:0] pselx;
	 bit pwrite;
	
	extern function new(string name = "apb_trans"); 
	extern function void do_print(uvm_printer printer);
	
endclass

function apb_trans:: new(string name = "apb_trans");
	super.new(name);
endfunction

function void apb_trans:: do_print(uvm_printer printer);
	super.do_print(printer);
	
	printer.print_field("paddr",  this.paddr, 32, UVM_DEC);
	printer.print_field("pwdata", this.pwdata, 32, UVM_DEC);
	printer.print_field("prdata", this.prdata, 32, UVM_DEC);
	printer.print_field("penable",this.penable, 1, UVM_BIN);
	printer.print_field("pselx",  this.pselx,  4, UVM_BIN);
	printer.print_field("pwrite", this.pwrite, 1, UVM_BIN);
	
endfunction