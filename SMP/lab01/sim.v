module sim;
	// AGP bus
	wire        pipe;      
	wire [ 7:0] sba; 
	wire        rbf;
	wire [ 2:0] st;
	wire        gnt;
	wire        ad_stb0;
	wire        ad_stb1;
	wire        sb_stb;
	reg         clk;
	wire        irdy;
	wire        trdy;
	wire        serr;
	wire        req;
	wire        rst;
	wire [31:0] ad;
	wire [ 3:0] c_be;
	wire        inta;
	wire        intb;

	core_logic cl(pipe, sba, rbf, st, gnt, ad_stb0, ad_stb1, sb_stb,
	             clk, irdy, trdy, serr, req, rst, ad, c_be, inta, intb);
	graphic_controller gc(pipe, sba, rbf, st, gnt, ad_stb0, ad_stb1, sb_stb,
	             clk, irdy, trdy, serr, req, rst, ad, c_be, inta, intb);

	// --- clock gen.---
	initial begin
		clk = 0;
              #1000 $stop;
	end
	always begin
		#10 clk = ~clk;
	end
	// --- end clock gen ---
	
endmodule
