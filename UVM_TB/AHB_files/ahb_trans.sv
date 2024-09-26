class ahb_trans extends uvm_sequence_item ;

	`uvm_object_utils(ahb_trans);
	
     rand bit [31:0]haddr;
	 rand bit [31:0]hwdata;
	 bit [31:0]hrdata;
	 rand bit [1:0] htrans;
	 rand bit [2:0] hsize;
	 rand bit [2:0] hburst;
	 bit [1:0] hresp;
	 rand bit [9:0] length;
     bit hresetn,hready_out, hready_in;
	 rand bit hwrite;
	 
	 constraint write_value { hwrite dist{1:=50, 0:= 50};}
	 
	 constraint valid_size {hsize inside {[0:2]};}
	 
	 constraint valid_addr {haddr inside {[32'h8000_0000:32'h8000_03ff],
										  [32'h8400_0000:32'h8400_03ff],
										  [32'h8800_0000:32'h8800_03ff],
										  [32'h8c00_0000:32'h8c00_03ff]};}
										  
   constraint valid_length {
    if (hburst == 3'b000) length == 1;
    else if (hburst == 3'b001) (haddr % 1023) + (length * (2 ** hsize)) <= 1023;
    else if (hburst == 3'b010) length == 4;
    else if (hburst == 3'b011) length == 4;
    else if (hburst == 3'b100) length == 8;
    else if (hburst == 3'b101) length == 8;
    else if (hburst == 3'b110) length == 16;
    else if (hburst == 3'b111) length == 16;
}
	
	constraint valid_hsize {if(hsize == 3'b001) haddr%2 == 0;
							if(hsize == 3'b010) haddr%4 == 0;}
	
	extern function new(string name = "ahb_trans"); 
	extern function void do_print(uvm_printer printer);
	
endclass

function ahb_trans:: new(string name = "ahb_trans");
	super.new(name);
endfunction

function void ahb_trans:: do_print(uvm_printer printer);
	super.do_print(printer);
	
	printer.print_field("haddr", this.haddr, 32, UVM_DEC);
	printer.print_field("hwdata", this.hwdata, 32, UVM_DEC);
	printer.print_field("hrdata", this.hrdata, 32, UVM_DEC);
	printer.print_field("htrans", this.htrans, 2, UVM_BIN);
	printer.print_field("hsize", this.hsize,  3, UVM_BIN);
	printer.print_field("hburst", this.hburst, 3, UVM_BIN);
	printer.print_field("hresp", this.hresp,  2, UVM_BIN);
	printer.print_field("length", this.length, 10, UVM_DEC);
	printer.print_field("hresetn", this.hresetn,1, UVM_BIN);
	printer.print_field("hwrite", this.hwrite,1, UVM_BIN);
	printer.print_field("hready_in", this.hready_in,1, UVM_BIN);
	printer.print_field("hready_out", this.hready_out,1, UVM_BIN);
	
endfunction