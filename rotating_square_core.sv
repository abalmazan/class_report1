module rotating_square_core #(
  parameter int STEP_M = 50_000_000
)(
  input  logic clk,
  input  logic reset,
  input  logic en,
  input  logic cw,
  output logic [7:0] in3, in2, in1, in0
);

  localparam int W = $clog2(STEP_M);
  logic [W-1:0] cnt;

  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      cnt <= '0;
    else if (en)
      cnt <= (cnt == STEP_M-1) ? '0 : cnt + 1'b1;
  end

  wire step_tick = (cnt == STEP_M-1);

  logic [2:0] state_reg, state_next;

  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      state_reg <= 3'd0;
    else if (step_tick)
      state_reg <= state_next;
  end

  always_comb begin
    state_next = state_reg;
    if (en && step_tick) begin
      if (cw)
        state_next = state_reg - 3'd1;
      else
        state_next = state_reg + 3'd1;
    end
  end

  /* active-low: dp g f e d c b a */
  localparam logic [7:0] BLANK  = 8'hFF;
  localparam logic [7:0] TOP    = 8'b1_0_0_1_1_1_0_0; // a b f g
  localparam logic [7:0] BOTTOM = 8'b1_0_1_0_0_0_1_1; // c d e g

  always_comb begin
    in3 = BLANK;
    in2 = BLANK;
    in1 = BLANK;
    in0 = BLANK;

    case (state_reg)
      3'd0: in3 = TOP;
      3'd1: in2 = TOP;
      3'd2: in1 = TOP;
      3'd3: in0 = TOP;
      3'd4: in0 = BOTTOM;
      3'd5: in1 = BOTTOM;
      3'd6: in2 = BOTTOM;
      3'd7: in3 = BOTTOM;
      default: ;
    endcase
  end

endmodule
