module mc68000(
       clk,a,d,
	as_n,rw_n,uds_n,lds_n,dtack_n,
	br_n,bg_n,bgack_n,
	ip_n,
	fc,
	e,vma_n,vpa_n,
	berr_n,reset_n,halt_n );

	// declaring inputs & outputs
	
	input clk;
	// adrese & date
	output[23:0] a;
	output[15:0]  d;
	// bus control
	output as_n, rw_n, uds_n, lds_n;
	input  dtack_n;
	// bus control
	input  br_n, bgack_n;
	output bg_n;
	// interrupt control
	input [2:0]ip_n;
	output [2:0]fc;
	// peripheral control
	output e,vma_n;
	input  vpa_n;
	// status


	// system control
	input berr_n;
	input reset_n;
       output halt_n;
	
	// internal registers & wires
	
       // procesorul functioneaza in felul urmator 
       // porneste cu o scriere la adresa 0 
       // citeste de la adresa 0
       // scrie la adresa 1.  etc ...
      
       // registrul intern de adrese
	reg[23:0] address;
	assign a = address;
	
       // registru de date
	reg[15:0] data;
       assign d = (rw_n == 1)? 16'bz:data; 

       	
       // semanlele cu care lucram pentru accesul la memorie
	reg ras_n, rrw_n, ruds_n, rlds_n;
	assign as_n=ras_n;
	assign rw_n=rrw_n;
	assign uds_n=ruds_n;
	assign lds_n=rlds_n;
	
       // nu se folosesc in aceasta simulare
	reg rbg_n;
  	assign bg_n=rbg_n;
	reg re, rvma_n;
	assign e=re;
	assign vma_n=rvma_n;
	reg [2:0]rfc;
	assign fc=rfc;



       // status register (se pastreaza starea urmatoare a procesorul, determinata in functie de ce a fost citit din memorie)
       reg[2:0] state;
       reg current; // instructiunea curenta
       reg mc_clk;  // clk intern
       reg [23:0] c_address; 
       reg [15:0] c_data;

       initial begin // este inlocuit de reset
//        state = 3'b111;
//        current = 1'b1; // instructiune de citire
//        c_address = 24'b0;

//        address = 24'bz;
//        data = 16'bz;
/*        ras_n =1'b1;
        mc_clk = 1'b0;
	 ras_n = 1'b1;
	 rrw_n = 1'b1;
        ruds_n = 1'b1;
        rlds_n = 1'b1;
*/
       end
       // ceasul intern sincronizat cu ceasul extern si depinde de reset
       always @ (posedge clk) begin
                      mc_clk = reset_n;
                             end
       always @ ( negedge clk) begin
                       mc_clk = 0;
                       end
           // daca apare reset se reseteaza toti registri
       always @ (negedge reset_n)
               begin 
                 state = 3'b111;
                 current = 1;
                 c_address = 24'b0;
                 c_data = 100;
                 address = 24'bz;
                 data = 16'bz;
                 ras_n = 1'b1;
      	          rrw_n = 1'b1;
                 ruds_n = 1'b1;
                 rlds_n = 1'b1;

               end



        // executie de instructiuni
       always @ (posedge mc_clk or negedge mc_clk) begin
               if(current == 1'b0) begin // ciclu de citire
                    case(state) 
                    
                        3'b111:begin //stare 0
                        // state 0 procesorul pune FC si rw_n pe read
                              rfc = 3'b000;
                              rrw_n = 1'b1;
                              address = 24'bz;
                              data = 16'bz;
                              state = state +1;
                             end 
                        3'b000:begin //stare 1
                        // state 1 procesorul pune o adresa valida
                              address = c_address;
                              state = state+1;
                              end
                        3'b001:begin //stare 2
                        // pune AS UDS LDS 
                              ras_n = 1'b0;
                              ruds_n = 1'b0;
                              rlds_n = 1'b0;
                              state = state +1;
                              end
                        3'b010:begin //stare 3
                        // raman toate semnalele la fel
                              state = state+1;
                              end
                        3'b011:begin //stare 4
                        // se testeaza dtack_n ; daca dtack_n == 0 se continua cu pasul 5 altfel se ramane la pasul 4
                              if(dtack_n == 0) begin 
                                    state = state+1; 
                                    end
                              else begin 
                                    state = state -1;
                                    end
                              end
                        3'b100:begin //stare 5
                        // raman toate semnalele la fel
                              state = state+1;
                              end
                        3'b101:begin //stare 6
                        // sunt citite datele
                              state = state+1;
                              end
                        3'b110:begin //stare 7
                        // neagate as_n, lds_n, ds_n ;
                              ras_n = 1'b1;
                              ruds_n = 1'b1;
                              rlds_n = 1'b1;
                              state = state +1;
                              c_address = c_address +2;
                              current = ~current;
                              end    

                   endcase
                   end
                else begin // scriere date
                      case(state) 
                        3'b111:begin //stare 0
                        // state 0 procesorul pune FC si rw_n pe write
                              rfc = 3'b000;
                              rrw_n = 1'b1;
                              address = 24'bz;
                              data = 16'bz;
                              state = state +1;
                             end 
                        3'b000:begin //stare 1
                        // state 1 procesorul pune o adresa valida
                              address = c_address;
                              state = state+1;
                              end
                        3'b001:begin //stare 2
                        // pune AS LS LDS 
                              ras_n = 1'b0;
                              rrw_n = 1'b0;
                              state = state +1;
                              end
                        3'b010:begin //stare 3
                        // raman toate semnalele la fel
                              data = c_data;
                              state = state+1;
                              end
                        3'b011:begin //stare 4
                        // se testeaza dtack_n ; daca dtack_n == 0 se continua cu pasul 5 altfel se ramane la pasul 4
                              ruds_n = 1'b0;
                              rlds_n = 1'b0;
                              state = state + 1;
                              end
                        3'b100:begin //stare 5
                        // raman toate semnalele la fel
                             if(dtack_n == 0) begin 
                                    state = state+1; 
                                    end
                              else begin 
                                    state = state -1;
                                    end
                              end
                        3'b101:begin //stare 6
                        // raman toate semnalele la fel
                              state = state +1;
                              end
                        3'b110:begin //stare 7
                        // neagate as_n, lds_n, ds_n ;
                              ras_n = 1'b1;
                              ruds_n = 1'b1;
                              rlds_n = 1'b1;
                              state = state +1;
                              c_address = c_address ;
                              c_data = c_data + 1;
                              current = ~current;
                               end    
                                        
                  endcase
                  end//end else 
          end//always
 
                   

endmodule	



