module tick_gen (
    input  logic clk,
    input  logic rst,
    output logic tick
);
    // 100 MHz / 100,000 = 1 kHz
    logic [16:0] count;

    always_ff @(posedge clk) begin
        if (rst) begin
            count <= 0;
            tick  <= 1'b0;
        end else begin
            if (count == 17'd99999) begin
                count <= 0;
                tick  <= 1'b1;
            end else begin
                count <= count + 1;
                tick  <= 1'b0;
            end
        end
    end
endmodule
