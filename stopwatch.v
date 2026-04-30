//StopWatch: Modulo-60 Counter
module stopwatch(
    input clk,
    input rst,
    input en,
    output [5:0] count     //6-bits to represent the highest number 59
);
    // wires to connect the DFF's 
    wire c1, c2, c3, c4, c5;
    wire at_count, c_reset;
 
    // set reset conditions, either at 60 secs, or if rst is pressed
    assign at_count = (count[5] & count[4] & count[3] & count[2] & ~count[1] & ~count[0]); //111100 reset at 60
    assign c_reset = at_count | rst;
    
    //instantiate D Flip Flops 
    DFlipFlopR dff0 (.Clk(clk), .Rst(c_reset), .En(en), .Q(count[0]));
    DFlipFlopR dff1 ( .Clk(clk), .Rst(c_reset), .En(en), .Q(count[1]));
    DFlipFlopR dff2 (.Clk(clk), .Rst(c_reset), .En(en), .Q(count[2]));
    DFlipFlopR dff3 ( .Clk(clk), .Rst(c_reset), .En(en), .Q(count[3]));
    DFlipFlopR dff4 (.Clk(clk), .Rst(c_reset), .En(en), .Q(count[4]));
    DFlipFlopR dff5 ( .Clk(clk), .Rst(c_reset), .En(en), .Q(count[5]));
    
    //Instantiate Full adders and connect them to the DFF's
    full_adder fa0 (.A(count[0]), .B(en),   .Cin(1'b0), .Y(dff0.D), .Cout(c1));
    full_adder fa1 ( .A(count[1]), .B(1'b0),   .Cin(c1),   .Y(dff1.D), .Cout(c2));
    full_adder fa2 (.A(count[2]), .B(1'b0),   .Cin(c2),   .Y(dff2.D), .Cout(c3));
    full_adder fa3 ( .A(count[3]), .B(1'b0),   .Cin(c3),   .Y(dff3.D), .Cout(c4));
    full_adder fa4 (.A(count[4]), .B(1'b0),   .Cin(c4),   .Y(dff4.D), .Cout(c5));
    full_adder fa5 ( .A(count[5]), .B(1'b0),   .Cin(c5),   .Y(dff5.D), .Cout());

   
endmodule


module DFlipFlopR (
    input D,
    input Clk,
    input Rst,
    input En,
    output reg Q
);

    initial begin
        Q <= 0;
    end
       
    always @(posedge Clk, posedge Rst) begin
        if (Rst)     Q <= 0;
        else if (En) Q <= D;
    end

endmodule

module full_adder (
    input A, B, Cin,
    output Y,
    output Cout
);
    wire Sum;
    assign Sum = A^B;
    assign Y = Sum ^ Cin;
    assign Cout = (A & B) | (Sum & Cin);

endmodule

