class ahb_sequence extends uvm_sequence #(ahb_trans);

	`uvm_object_utils(ahb_sequence);
	
	function new(string name = "ahb_sequence");
		super.new(name);
	endfunction
	
endclass

class single_seqs extends ahb_sequence;
	
	`uvm_object_utils(single_seqs);
	
	bit[1:0] haddr;
	bit[2:0] hburst;
	bit hwrite;

	function new(string name = "single_seqs");
		super.new(name);
	endfunction
	
	task body();
		repeat(2)
		begin
		req = ahb_trans::type_id::create("ahb_trans");
		start_item(req);
		assert (req.randomize() with { htrans == 2'b10;
									   hburst == 3'b000;
										hwrite == 1'b1;});
		finish_item(req);
	
	haddr = req.haddr;
	hburst = req.hburst;
	hwrite = req.hwrite;
	   end
	endtask
	
endclass

class inc_trf_seqs extends ahb_sequence;
	
	`uvm_object_utils(inc_trf_seqs);
	
	bit[31:0] Haddr;
	bit[2:0] Hburst;
	bit[2:0] Hsize;
	bit[9:0] Length;
	bit Hwrite;
	
	function new(string name = "inc_trf_seqs");
		super.new(name);
	endfunction
	
	task body();
		req = ahb_trans::type_id::create("ahb_trans");
		start_item(req);
		assert (req.randomize() with { htrans == 2'b10;
							   hburst inside {3'd1,3'd3,3'd5,3'd7};});
							   
		finish_item(req);
	
	
	this.Haddr = req.haddr;
	this.Hburst = req.hburst;
	this.Hsize = req.hsize;
	this.Hwrite = req.hwrite;
	this.Length = req.length;
	
	for(int i=1; i<= Length; i++)
	begin
		start_item(req);
		assert (req.randomize() with { htrans == 2'b11;
								hsize == Hsize;
								hwrite == Hwrite;
								hburst == Hburst;
								haddr == (Haddr +(2**hsize));});
		finish_item(req);
		this.Haddr = req.haddr;
	end	
	endtask

endclass
	
class wrap_trf_seqs extends ahb_sequence;
	
	`uvm_object_utils(wrap_trf_seqs);
	
	bit[31:0] Haddr;
	bit[2:0] Hsize;
	bit[9:0] Length;
	bit[2:0] Hburst;
	bit Hwrite;
	bit [31:0] start_addr;
	bit [31:0] boundry_addr;
	
	function new(string name = "wrap_trf_seqs");
		super.new(name);
	endfunction
	
	task body();
		req = ahb_trans::type_id::create("ahb_trans");
		start_item(req);
		assert (req.randomize() with { htrans == 2'b10;
							   hburst inside {3'd2,3'd4,3'd6};});
							   
		finish_item(req);
	
	
	this.Haddr = req.haddr;
	this.Hsize = req.hsize;
	this.Hwrite = req.hwrite;
	this.Length = req.length;
	this.Hburst = req.hburst;
	
	start_addr = (Haddr/((2**Hsize)*Length))*((2**Hsize)*Length);
	
	boundry_addr = start_addr + ((2**Hsize)*Length);
	Haddr = req.haddr + (2**Hsize);
	
	for(int i=1; i<= Length; i++)
	begin
		if(Haddr >= boundry_addr)
			Haddr = start_addr;
			start_item(req);
			assert (req.randomize() with { htrans == 2'b11;
									hsize == Hsize;
									hwrite == Hwrite;
									hburst == Hburst;
									haddr == Haddr ;});
			finish_item(req);
			Haddr = req.haddr +(2**Hsize);
	end	
	endtask
	
	
	
endclass
