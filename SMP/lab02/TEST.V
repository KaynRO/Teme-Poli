module test;

reg [23:0]address;
reg [15:0]data;
reg clk;                           // Clock
reg cs_n;                          // CS#
reg oe_n;
   

// semanlele cu care lucram pentru accesul la memorie
reg as_n, rw_n, uds_n, lds_n;
// nu se folosesc in aceasta simulare
reg br_n, bg_n, bgack_n;
reg e, vma_n, vpa_n;
reg [2:0]fc;
reg berr_n;
reg reset_n,halt_n;
reg [2:0]ip_n;


wire [15:0]dat;always @(dat) data=dat;
wire [23:0]mcaddress; always @(mcaddress) address = mcaddress;

wire mcas_n ;always @(mcas_n) as_n = mcas_n;
wire mcrw_n ;always @(mcrw_n) rw_n = mcrw_n;
wire mcuds_n ;always @(mcuds_n) uds_n = mcuds_n;
wire mclds_n ;always @(mclds_n) lds_n = mclds_n;
wire dtack_n = mclds_n || mcuds_n;

wire mcbg_n = bg_n;
wire mcreset_n = reset_n;
wire mchalt_n = halt_n;
wire mce = e;
wire mcwma_n = vma_n;
wire [2:0]mcfc;
always @(mcfc) fc = mcfc;

parameter half_clk =  1;
parameter full_clk = 2;


//ram8kx8 sdram0 (rw_n, oe_n, cs_n, address, [7:0]dat);
ram8kx8 sdram0 (mcas_n & mcrw_n, ~mcrw_n, mclds_n, mcaddress[13:1], dat[7:0]);
ram8kx8 sdram1 (mcas_n & mcrw_n, ~mcrw_n, mcuds_n, mcaddress[13:1], dat[15:8]);
mc68000 mc(
       clk,mcaddress,dat,
	mcas_n,mcrw_n,mcuds_n,mclds_n,mclds_n || mcuds_n,//dtack_n,
	br_n,mcbg_n,bgack_n,
	ip_n,
	mcfc,
	mce,mcvma_n,vpa_n,
	berr_n,mcreset_n,mchalt_n );


initial begin
    clk = 1'b0;
    cs_n = 1'b1;
    data = 16'bz;
    address = 24'bz;
    oe_n = 1;
    reset_n = 1'b0;
    fc = 3'bz;


end

always #half_clk clk = ~clk;

initial begin
//  reset;
  #10;reset_n = 1'b1;
  #50;reset_n = 1'b0;
  #10;reset_n = 1'b1;
  #50;
  $stop;
  $finish;
  end           
endmodule
