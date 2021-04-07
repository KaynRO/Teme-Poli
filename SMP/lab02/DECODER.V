module decoder( address, o);

input [9:0] address;
output o;

assign o = (|address);
endmodule
