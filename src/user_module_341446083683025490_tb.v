
//`include "user_module_341446083683025490.v"

module user_module_341446083683025490_tb;

// TEST VARS
    parameter T_CLK = 10;

// DUT LOGIC
    wire [7:0] io_in;
    wire [7:0] io_out;

    reg        i_clk;
    reg        i_rst;
    reg        i_roll;
    reg        i_load;
    reg  [2:0] i_seed;
    wire [7:0] o_led;
    
    assign io_out     = o_led;
    assign io_in[0]   = i_clk;
    assign io_in[1]   = i_rst;
    assign io_in[2]   = i_roll;
    assign io_in[3]   = i_load;
    assign io_in[6:4] = i_seed; 

    user_module_341446083683025490 DUT (
        .io_in  (io_in),
        .io_out (io_out)
    );

// CLOCK GENERATION
    initial i_clk = 0;
    always#(T_CLK/2) i_clk = !i_clk;

// SIM TASKS
    task resetDut;
    begin 
        i_rst = 1;
        @(posedge i_clk);
        i_rst = 0;
        @(posedge i_clk);
    end 
    endtask

    task loadSeed;
    input [2:0] seed;
    begin 
        @(posedge i_clk) begin 
            i_load <= 1;
            i_seed <= seed;
        end 
        @(posedge i_clk) begin 
            i_load <= 0;
            i_seed <= 0;
        end 
    end 
    endtask

    task rollDice;
    begin 
        @(posedge i_clk) i_roll <= 1;
        @(posedge i_clk) i_roll <= 0;
    end 
    endtask

// MAIN SIM
    initial begin 
        i_rst  = 1;
        i_roll = 0;
        i_load = 0;
        i_seed = 0;
        #100;
        i_rst = 0;

        loadSeed(3'b101);

        rollDice();
        #20;

        rollDice();
        #20;

        rollDice();
        #20;

        #100;
        $finish();
    end 

endmodule
