library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity transmitter is
    port (
        yclk : in std_logic;                        -- clock input
        ypdata : in std_logic_vector(7 downto 0);   -- parallel data in
        yload : in std_logic;                       -- load signal, active high
        ybusy : out std_logic:= '0';                -- busy indicator
        ysdata : out std_logic:= '1'                -- serial data out
        );                   
end transmitter;


architecture Behavioral of transmitter is

    type state_type is (IDLE, TRANSMIT);
    signal current_state, next_state : state_type := IDLE;
    constant duration : integer := 10417;
    signal counter : integer := 0;
    signal state : integer range 0 to 8 := 0;

begin

SYNCHRONOUS_PROCESS : process(yclk) -- state register
 
    begin
   
        if rising_edge(yclk) then
            current_state <= next_state;
       
            if current_state = IDLE then
                ysdata <= '1'; -- added. It was in out FSM but not here
                counter <= 0;
                state <= 0;
                ybusy <= '0';
                       
            else
                counter <= counter + 1;
               
                if current_state = TRANSMIT then
                    ybusy <= '1';
                   
                    if counter = 0 then
                        ysdata <= '0';
                   
                    elsif (counter = (state+1) * duration) and (state < 8) then
                        ysdata <= ypdata(state);
                         state <= state + 1;
                       
                    elsif counter = 9 * duration then -- Added toreturn to idle properly. At 8 times duration, our last bit starts being sent. It is at 9 times duration that the cycle of our last bit ends and the 1 stop bit starts.
                         ysdata <= '1';
                        
                       
                       -- if state < 8 then
                       --     state <= state + 1;
                       -- else
                        --    ysdata <= '1';
                        end if;
                    end if;
                end if;
            end if;
    
    end process;

COMBINATIONAL_PROCESS : process(current_state, ypdata, counter, state, yload) -- next state and output logic
   
    begin
   
        next_state <= current_state;
       
        case current_state is
            when IDLE =>
                if yload = '1' then
                    next_state <= TRANSMIT;
                else
                    next_state <= IDLE;
                end if;
                   
            when TRANSMIT =>
                if counter = 10 * duration then -- at 10, the stop bit clock cycle ends and we move to IDLE.
                    next_state <= IDLE;
                end if;
        end case;
   
    end process;

end Behavioral;

