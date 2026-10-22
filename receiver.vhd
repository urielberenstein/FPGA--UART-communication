library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity receiver is
    port (
        clk : in std_logic;
        reset : in std_logic;
        sdata : in std_logic;
        pdata : out std_logic_vector(7 downto 0);
        ready : out std_logic
    );
end receiver;

architecture Behavioral of receiver is

    type state_type is (IDLE, START, READ, STOP, READYs);
    signal current_state, next_state : state_type;
    signal counter : integer := 0;
    constant duration : integer := 10417;
    signal state : integer range 0 to 8 := 0;
   
begin
   
    ASYNCHRONOUS_PROCESS : process(clk, reset) -- state register
 
    begin
   
        if reset = '1' then
            counter <= 0;
            current_state <= IDLE;
            state <= 0;
            pdata <= (others => '0');
           
            elsif rising_edge(clk) then
                current_state <= next_state;
               
                if current_state = IDLE then
                    counter <= 0;
                    state <= 0;
                   
                    else
                    counter <= counter + 1;
                   
                    if current_state = READ then
                        if (counter = state * duration + duration * 15/10) and (state < 8) then
                            pdata(state) <= sdata;
                        if state < 8 then
                            state <= state + 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
       
    end process;
   
   
    COMBINATIONAL_PROCESS : process(current_state, sdata, reset, counter, state) -- next state and output logic
   
    begin
       
        next_state <= current_state;
        ready <= '0';
       
        case current_state is
            when IDLE =>
                if sdata = '0' then
                    next_state <= START;
                else
                    next_state <= IDLE;
                end if;
               
               
            when START =>
                if (counter = duration / 2) then
                    if sdata = '0' then
                        next_state <= READ;              
                    else
                        next_state <= IDLE;
                    end if;
               end if;
               
               
            when READ =>
                if (state = 8) then
                    next_state <= STOP;
                           
                end if;
           
           
            when STOP =>                    
                if (counter = state * duration + duration * 15/10) then    
                    if sdata = '1' then
                        next_state <= READYs;
                    else
                        next_state <= IDLE;
                    end if;
                end if;
                             
            when READYs =>
                ready <= '1';
               
                next_state <= IDLE;
                           
        end case;
       
    end process;

end Behavioral;
