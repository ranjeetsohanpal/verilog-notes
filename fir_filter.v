module FIR_Filter #(parameter WIDTH = 8) (
    input wire clk,
    input wire rst,
    input wire signed [WIDTH-1:0] x_in,  // Input signal
    output reg signed [WIDTH+1:0] y_out  // Output signal (extra bits for accumulation)
);

// Filter Coefficients
reg signed [WIDTH-1:0] h0 = 8'd1, h1 = 8'd2, h2 = 8'd1;  // Example coefficients

// Delay line (to store previous inputs)
reg signed [WIDTH-1:0] x1, x2;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset filter memory and output
        x1 <= 0;
        x2 <= 0;
        y_out <= 0;
    end else begin
        // Shift input data through the delay line
        x2 <= x1;
        x1 <= x_in;

        // Apply FIR filter: y[n] = h0*x[n] + h1*x[n-1] + h2*x[n-2]
        y_out <= h0 * x_in + h1 * x1 + h2 * x2;
    end
end

endmodule
