class sb extends uvm_scoreboard;

	`uvm_component_utils(sb);
	
	uvm_tlm_analysis_fifo #(ahb_trans) fifo_ahb;
	uvm_tlm_analysis_fifo #(apb_trans) fifo_apb;
	
	ahb_trans h_trans;
	apb_trans p_trans;
	
	//ahb_trans ahb_cov_data;
	//apb_trans apb_cov_data;
	
	env_config m_cfg;
	
	extern function new ( string name = "sb", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task check_data(ahb_trans h_xtn, apb_trans p_xtn);
	extern task compare(int haddr, paddr, hdata, pdata);
	
	covergroup cg1;
	
		option.per_instance = 1;
		
		HADDR: coverpoint h_trans.haddr { 
											bins slave_1 = { [32'h8000_0000:32'h8000_03ff]};
											bins slave_2 = { [32'h8400_0000:32'h8400_03ff]};
											bins slave_3 = { [32'h8800_0000:32'h8800_03ff]};
											bins slave_4 = { [32'h8c00_0000:32'h8c00_03ff]};
										}
		
		HSIZE: coverpoint h_trans.hsize { 
											bins byte_1 ={0};
											bins byte_2 ={1};
											bins byte_4 ={2};
										}
										
		HWRITE: coverpoint h_trans.hwrite{ 
											bins write ={1};
											bins read ={0};
										}
										
		HTRANS: coverpoint h_trans.htrans {
											bins non_seq ={2'b10};
											bins seq = {2'b11};
										  }
										  
		ADDR_X_HSIZE_X_HWRITE_X_HTRANS: cross HADDR, HWRITE, HSIZE, HTRANS;
		
	endgroup
	
	covergroup cg2;
	
		option.per_instance = 1;
		
		PADDR: coverpoint p_trans.paddr { 
											bins slave_1 = { [32'h8000_0000:32'h8000_03ff]};
											bins slave_2 = { [32'h8400_0000:32'h8400_03ff]};
											bins slave_3 = { [32'h8800_0000:32'h8800_03ff]};
											bins slave_4 = { [32'h8c00_0000:32'h8c00_03ff]};
										}
										
		PSELX: coverpoint p_trans.pselx {
											bins selx_1 ={1};
											bins selx_2 ={2};
											bins selx_3 ={4};
											bins selx_4 ={8};
										}
		
	endgroup
	
endclass

function sb :: new(string name = "sb", uvm_component parent);
	super.new(name,parent);
	cg1 = new();
	cg2 = new();
endfunction

function void sb:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	fifo_ahb = new("fifo_ahb", this);
	fifo_apb = new("fifo_apb", this);
endfunction

task sb:: run_phase(uvm_phase phase);
	
	forever
	begin
		fork
			begin
				fifo_ahb.get(h_trans);
				`uvm_info(get_type_name(),$sformatf("printing the fifo_ahb_trans = %s",h_trans.sprint),UVM_LOW);
				cg1.sample();
			end
			
			begin
				fifo_apb.get(p_trans);
				`uvm_info(get_type_name(),$sformatf("printing the fifo_apb_trans = %s",p_trans.sprint),UVM_LOW);
				cg2.sample();
			end
		join
	
	check_data(h_trans, p_trans);
	end
	
endtask

task sb:: check_data(ahb_trans h_xtn, apb_trans p_xtn);

	if(h_trans.hwrite == 1)
		begin
			if(h_trans.hsize == 2'b00)
				begin
					if(h_trans.haddr[1:0] == 2'b00)
						compare(h_trans.haddr, p_trans.paddr, h_trans.hwdata[7:0], p_trans.pwdata);
						
					if(h_trans.haddr[1:0] == 2'b01)
						compare(h_trans.haddr, p_trans.paddr, h_trans.hwdata[15:8], p_trans.pwdata);
						
					if(h_trans.haddr[1:0] == 2'b10)
						compare(h_trans.haddr, p_trans.paddr, h_trans.hwdata[23:16], p_trans.pwdata);
						
					if(h_trans.haddr[1:0] == 2'b11)
						compare(h_trans.haddr, p_trans.paddr, h_trans.hwdata[31:24], p_trans.pwdata);
				end
				
			if(h_trans.hsize == 2'b01)
				begin
					if(h_trans.haddr[1:0] == 2'b00)
						compare(h_trans.haddr, p_trans.paddr, h_trans.hwdata[15:0], p_trans.pwdata);
						
					if(h_trans.haddr[1:0] == 2'b10)
						compare(h_trans.haddr, p_trans.paddr, h_trans.hwdata[31:16], p_trans.pwdata);
				end
				
			if(h_trans.hsize == 2'b10)
				begin
					compare(h_trans.haddr, p_trans.paddr, h_trans.hwdata, p_trans.pwdata);
				end
		end
		
	if(h_trans.hwrite == 0)
		begin
			if(h_trans.hsize == 2'b00)
				begin
					if(h_trans.haddr[1:0] == 2'b00)
						compare(h_trans.haddr, p_trans.paddr, h_trans.hrdata, p_trans.prdata[7:0]);
						
					if(h_trans.haddr[1:0] == 2'b01)
						compare(h_trans.haddr, p_trans.paddr, h_trans.hrdata, p_trans.prdata[15:8]);
						
					if(h_trans.haddr[1:0] == 2'b10)
						compare(h_trans.haddr, p_trans.paddr, h_trans.hrdata, p_trans.prdata[23:16]);
						
					if(h_trans.haddr[1:0] == 2'b11)
						compare(h_trans.haddr, p_trans.paddr, h_trans.hrdata, p_trans.prdata[31:24]);
				end
				
			if(h_trans.hsize == 2'b01)
				begin
					if(h_trans.haddr[1:0] == 2'b00)
						compare(h_trans.haddr, p_trans.paddr, h_trans.hrdata, p_trans.prdata[15:0]);
						
					if(h_trans.haddr[1:0] == 2'b10)
						compare(h_trans.haddr, p_trans.paddr, h_trans.hrdata, p_trans.prdata[31:16]);
				end
				
			if(h_trans.hsize == 2'b10)
				begin
					compare(h_trans.haddr, p_trans.paddr, h_trans.hrdata, p_trans.prdata);
				end
		end
endtask


task sb:: compare(int haddr, paddr, hdata, pdata);	
	
	if(haddr == paddr)
		$display("ADDRESS are sucessfully matching");
	else
begin
		$display("ADDRESS are NOT matching");
$display("-----------------%d,APB= %d",haddr,paddr);
end
		
	if(hdata == pdata)
		$display("DATA are sucessfully matching");
	else
		$display("DATA are NOT matching");
endtask
	
	
