//Timer: Mod-60 downcounter with synchronous load
module timer(
    input clk,
    input rst,
    input en,               //Enables or Disables clock
    input load,             //If load=1, load the counter with "load_value"
    input [5:0] load_value, //Value to load into counter register. Counter will then start counting from this value
    output [5:0] state     //6-bits to represent the highest number 59
);

    // create count to loop through the always block, since state wouldn't work as-is
    reg [5:0] count;

    assign state = count;

    always @(posedge clk or posedge rst) begin
        if (rst) // reset value to 0
            count <= 6'd0;
        else if (load) 
            // make the load_value 59 if its > 59
            count <= (load_value > 6'd111100) ? 6'd111100 : load_value;
        else if (en) // actual timer logic
            if (count == 0)
                count <= 6'd0; // make sure it doesn't wrap-around since "count - 1" autowraps
            else
                count <= count - 1; 
    end

endmodule