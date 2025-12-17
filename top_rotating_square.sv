module top_rotating_square (
  input  logic        CLK100MHZ,
  input  logic        BTNC,
  input  logic [15:0] SW,
  output logic [15:0] LED,
  output logic [7:0]  AN,
  output logic        CA, CB, CC, CD, CE, CF, CG, DP
);

  logic reset, en, cw;
  logic [7:0] in0, in1, in2, in3;
  logic [7:0] sseg;
  logic [3:0] an4;

  assign reset = BTNC;
  assign en    = SW[0];
  assign cw    = SW[1];

  rotating_square_core u_core (
    .clk   (CLK100MHZ),
    .reset (reset),
    .en    (en),
    .cw    (cw),
    .in3   (in3),
    .in2   (in2),
    .in1   (in1),
    .in0   (in0)
  );

  disp_mux u_mux (
    .clk   (CLK100MHZ),
    .reset (reset),
    .in3   (in3),
    .in2   (in2),
    .in1   (in1),
    .in0   (in0),
    .an    (an4),
    .sseg  (sseg)
  );

  assign AN = {4'b1111, an4};

  assign CA = sseg[0];
  assign CB = sseg[1];
  assign CC = sseg[2];
  assign CD = sseg[3];
  assign CE = sseg[4];
  assign CF = sseg[5];
  assign CG = sseg[6];
  assign DP = sseg[7];

  assign LED = 16'b0;

endmodule

