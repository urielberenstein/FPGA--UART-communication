
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity transmitter_tb is
end transmitter_tb;

architecture Behavioral of transmitter_tb is

    -- Component declaration
    component transmitter
        port (
            yclk   : in std_logic;
            ypdata : in std_logic_vector(7 downto 0);
            yload  : in std_logic;
            ybusy  : out std_logic;
            ysdata : out std_logic
        );
    end component;

    -- Testbench signals
    signal clk   : std_logic := '0';
    signal pdata : std_logic_vector(7 downto 0) := (others => '0');
    signal load  : std_logic := '0';
    signal busy  : std_logic;
    signal sdata : std_logic;

    -- Timing constants
    constant CLK_PERIOD : time := 10 ns;
    constant BIT_TIME   : time := 104170 ns;

begin

    -- Instantiate the transmitter
    UUT : transmitter
        port map (
            yclk   => clk,
            ypdata => pdata,
            yload  => load,
            ybusy  => busy,
            ysdata => sdata
        );

    -- Generate 100 MHz clock
    CLOCK_PROCESS : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;

        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;


    -- Test procedure
    STIMULUS_PROCESS : process

        procedure SEND_BYTE( -- procedure declaration. As sson as the code sees the first SEND BYTE, it enters to this procedure
            constant DATA : in std_logic_vector(7 downto 0)
        ) is
        begin

            -- Load the parallel data
            pdata <= DATA;
            load <= '1'; -- load only becomes asserted for 1 clock cycle and makes the idle state move to transmit

            -- Keep load high for one clock cycle
            wait until rising_edge(clk);
            wait for 1 ns;

            load <= '0';

            -- Allow the FSM to enter TRANSMIT
            wait for CLK_PERIOD;

            -- Check start bit
            assert sdata = '0'
                report "ERROR: Start bit is incorrect."
                severity error;

            assert busy = '1'
                report "ERROR: Busy should be HIGH."
                severity error;

            -- Check all 8 data bits
            for i in 0 to 7 loop

                wait for BIT_TIME; -- this wait time is for the start bit to have its clock cycle before starting checking the first bit

                assert sdata = DATA(i)
                    report "ERROR: Incorrect data bit "
                           & integer'image(i)
                    severity error;

                assert busy = '1'
                    report "ERROR: Busy went LOW during transmission." -- we also check that busy is still 1 during the 8 bit process
                    severity error;

            end loop;

            -- Check stop bit
            wait for BIT_TIME;

            assert sdata = '1'
                report "ERROR: Stop bit is incorrect."
                severity error;

            -- Wait for the stop bit to finish
            wait for BIT_TIME;
            
            wait for 3*CLK_PERIOD;
            
            -- Check that transmitter returned to IDLE
            assert busy = '0'
                report "ERROR: Transmitter did not return to IDLE."
                severity error;

            assert sdata = '1'
                report "ERROR: Serial line should be HIGH in IDLE."
                severity error;

            -- Wait before sending another byte
            wait for 2 * BIT_TIME;

        end procedure;

    begin

        -- Allow initialization
        wait for 100 ns;

--check the transmitter is in idle before starting the precedure
        assert busy = '0'
            report "ERROR: Busy should be LOW in IDLE."
            severity error;

        assert sdata = '1'
            report "ERROR: Serial line should be HIGH in IDLE."
            severity error;


        -- TEST 1: Send character A (01000001)
        report "TEST 1: Sending character A.";

        SEND_BYTE("01000001");


        -- TEST 2: Send character B (01000010)
        report "TEST 2: Sending character B.";

        SEND_BYTE("01000010");


        -- End simulation
        report "Transmitter testbench finished.";

        wait;

    end process;

end Behavioral;