module vending_machine(
    input wire clk,        
    input wire rst,       
    input wire coin_in_en,  // Coin input enable
    input wire coin_val,    // Coin value input 0 for 2 cents, 1 for 10 cents
    output reg pencil_out,  
    output reg money_out,  
    output reg extra_money 
);

parameter pencil_cost = 6;
localparam IDLE = 3'b00;
localparam Accept = 3'b01;
localparam out_extra_money= 3'b010;

reg [1:0] state, next_state;
reg [3:0] money;
reg [2:0] remaining_money;

integer i;


always @(posedge clk or negedge rst) begin
    if (!rst)
     begin
        state <= IDLE;
        money <= 0;
    end
     else
     begin
        state <= next_state;
    end
end

// Combinational logic for next state and outputs
always@ (*)

 
begin
    case(state)
      
        IDLE: 
        begin
            pencil_out = 0;
            money_out = 0;
            extra_money = 0;
            if (coin_in_en)   //if coin_in_en=1
             begin
                if (coin_val == 0) //the customer enter 2 coins
                begin
                    money <= money + 2;
                end //for if (coin_val == 0) 
                
                 else   //coin_val = 1 , means the customer enter 10 coins
                 begin
                    money <= money + 10;
                 end  ///for else
                
                 next_state = Accept; //in case of (coin_in_en=1),the customer enter any no.of coins the state will switch to accepting 
                 
             end // for if (coin_in_en)
            
            else //if coin_in_en=0
            begin
                next_state = IDLE;  //in case of (coin_in_en=0),means the customer hasn't enter any coins so that the state will still at idle.
            end  //for else
        end //of IDLE
    ///////////////////////////////////////////////////////////////////////    

        
               Accept: 
        begin
          
          if (money < pencil_cost) //if customer enter money less than pencil cost then the state still at accepting and wait the customer to enter more money
            begin
                pencil_out = 0;
                money_out = 0;
                extra_money = 0;
                next_state = Accept;
            end //for if (money < PENCIL_COST)
            
            
          else if (money > pencil_cost)
             begin
                pencil_out = 1;
                money_out = 1;
                extra_money = 1;
                next_state = out_extra_money;
              end //for else if (money > PENCIL_COST)
              
            else        //if (money == pencil_cost)
              begin
                pencil_out = 1;
                money_out = 1;
                extra_money = 0;
                next_state = IDLE;
              end //for else (money = pencil_cost)
  
            
           
        end //for ACCEPTING
        
        /////////////////////////////////////////////////////////////////////////
        
        
        out_extra_money:
         begin
            remaining_money=money-pencil_cost;  //for example if customer enter 10 coins the remaining=4 coins, extra money=2 coins so we need two iterations to out the extra money.
           
           for (i=0;i< (remaining_money/2);i=i+1)
           begin
             extra_money = 1;
           end
           next_state = IDLE;
           
        end     //for out_extra_money 
        
        default:
         begin
            pencil_out = 0;
            money_out = 0;
            extra_money = 0;
            next_state = IDLE;
        end
        
        
    endcase
end   //of always block

endmodule
