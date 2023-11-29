// Code your design here


module fifo(data_out,fifo_full,fifo_empty,clk,wr_en,rd_en,rst,data_in);
 
  input clk,wr_en,rd_en,rst;
  input [7:0] data_in;
  output reg fifo_full,fifo_empty;
  reg [7:0] fifo_count;
  reg [7:0] mem[63:0];
  output [7:0] data_out;
  reg [5:0] wr_ptr,rd_ptr;
  
  
  
  // status of fifo
  always@(fifo_count)
    begin
      fifo_empty = (fifo_count == 0);
      fifo_full = (fifo_count == 64);
    end
  
  //counter
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        fifo_count <= 0;
      else if((!fifo_full && wr_en) &&(!fifo_empty && rd_en))
        //both happenning at the same time
        fifo_count <= fifo_count;
      else if(!fifo_empty && rd_en)
        fifo_count <= fifo_count - 1;
      else if(!fifo_full && wr_en)
        fifo_count <= fifo_count + 1;
      else 
        fifo_count <= fifo_count;
      
    end
  
  //read
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        data_out <= 0;
      else if(!fifo_empty && rd_en)
        data_out <= mem[rd_ptr];
      else
        data_out <= data_out;
    end
  
  //write
  always@(posedge clk)
    begin
      if(!fifo_full && wr_en)
        mem[wr_ptr] <= data_in;
      else 
        mem[wr_ptr] <= mem[wr_ptr];
    end
  
  //memory pointers
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        begin
          wr_ptr <= 0;
          rd_ptr <= 0;
        end
      else begin
        if(!fifo_full && wr_en)
          wr_ptr <= wr_ptr + 1;
        else 
          wr_ptr <= wr_ptr;
        if(!fifo_empty && rd_en)
          rd_ptr <= rd_ptr + 1;
        else 
          rd_ptr <= rd_ptr;
      end
    end
  
  
endmodule
