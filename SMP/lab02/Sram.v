module ram8kx8 (rw_n, oe_n, cs_n, a, d) ;

input rw_n ;
input oe_n ;
input cs_n ;
input [12:0] a ;
input [7:0] d ;

reg[12:0] address;
reg[7:0]  memo[12:0]; // 8 bytes (should be 8k)
reg[7:0]  outputbuf;
always @(negedge cs_n or negedge rw_n) begin
	// latching addresses
	address=a;
       outputbuf = memo[address];
       if(rw_n == 0) memo[address] = d;
end

assign d=(oe_n == 0)? outputbuf:8'bzzzzzzzz;
endmodule 

