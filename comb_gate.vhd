library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comb_gate is
    Port (
        cready : in STD_LOGIC;
        cbusy : in STD_LOGIC;
        cload : out STD_LOGIC);
end comb_gate;

architecture Behavioral of comb_gate is

begin
    process(cready, cbusy)
        begin
       
        if (cready = '1') and (cbusy = '0') then
            cload <= '1';
        else
            cload <= '0';
        end if;
       
    end process;

end Behavioral;
