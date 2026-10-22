library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port (
        tclk   : in  STD_LOGIC;
        treset : in  STD_LOGIC;
        tsdata : in  STD_LOGIC;
        tdata  : out STD_LOGIC
    );
end top;

architecture Behavioral of top is

    signal busy_wire  : STD_LOGIC;
    signal pdata_wire : STD_LOGIC_VECTOR(7 downto 0);
    signal ready_wire : STD_LOGIC;
    signal load_wire  : STD_LOGIC;

begin

    -- RECEIVER
    RX_INST : entity work.receiver
        port map (
            clk   => tclk,
            reset => treset,
            sdata => tsdata,
            pdata => pdata_wire,
            ready => ready_wire
        );

    -- COMBINATIONAL GATE
    GATE_INST : entity work.comb_gate
        port map (
            cready => ready_wire,
            cbusy  => busy_wire,
            cload  => load_wire
        );

    -- TRANSMITTER
    TX_INST : entity work.transmitter
        port map (
            yclk   => tclk,
            ypdata => pdata_wire,
            yload  => load_wire,
            ybusy  => busy_wire,
            ysdata => tdata
        );

end Behavioral;