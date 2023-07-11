library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;
--this is how entity for your test bench code has to be declared.
entity tb_fifo_axi is
   generic (
      runner_cfg : string
   );
end tb_fifo_axi;

architecture behavior of tb_fifo_axi is

    constant C_CLK_CYKLE : time := 10 ns;
    signal clk : std_logic;
    signal rst :  std_logic;

     -- Write port
    signal wr_en :  std_logic;
    signal wr_data :  std_logic_vector(32 - 1 downto 0);

    -- Read port
    signal rd_en : std_logic;
         --rd_valid : out std_logic;
    signal rd_data :  std_logic_vector(32 - 1 downto 0);

    -- Flags
    signal empty :  std_logic;
    signal empty_next : std_logic;
    signal full : std_logic;
    signal full_next : std_logic;

    -- The number of elements in the FIFO
    signal fill_count :integer range 256 - 1 downto 0;

    signal counter : integer := 0;

begin

   UUT : entity work.fifo_axi
     port map(
        clk => clk,
        rst => rst,

        -- Write port
        wr_en => wr_en,
        wr_data => wr_data,

        -- Read port
        rd_en => rd_en,
        --rd_valid : out std_logic;
        rd_data => rd_data,

        -- Flags
        empty => empty,
        empty_next => empty_next,
        full => full,
        full_next => full_next,

        fill_count => fill_count
   );



   clk        <= not(clk) after C_CLK_CYKLE/2;
   --S_AXI_ACLK <= not(clk) after AXI_clk_cyckle/2;

   rst <= '0';

   wr_data <= std_logic_vector(to_unsigned(counter,32));
   process (clk)
   begin
      if rising_edge(clk) then
         counter <= counter + 1;
         wr_en <= '1';
      else
        wr_en <= '0';

      end if;
   end process;
   rd_enable_p : process (clk)
   begin
      if rising_edge(clk) then

            rd_en <= '1';
      end if;
   end process;

   main_p : process
   begin
      test_runner_setup(runner, runner_cfg);
      while test_suite loop
         if run("wave") then

            wait for 8500 ns;

         elsif run("auto") then
            -- old tests that need to be updated
            --wait for 3845.1 ns; -- first rise (3845 ns after start)
            --check(data_valid_collector_out = '0', "fail!1 data_valid first rise");

            --wait for 5 ns; -- back to zero after first rise (3850 ns after start)
            --check(data_valid_collector_out = '0', "fail!2 data_valid back to zero after fist rise");

            --wait for 3835 ns; -- second rise (7685 ns after start)
            --check(data_valid_collector_out = '1', "fail!2 data_valid second rise");

            --wait for 5 ns; -- back to zero after second rise (7690 ns after start)
            --(data_valid_collector_out = '0', "fail!4 data_valid back to zero after second rise");

         end if;
      end loop;

      test_runner_cleanup(runner);
   end process;

   test_runner_watchdog(runner, 100 ms);

end architecture;