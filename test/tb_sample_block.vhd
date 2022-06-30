library IEEE;
use IEEE.STD_LOGIC_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

use work.MATRIX_TYPE.all;

entity tb_sample_block is
   generic (
      runner_cfg : string
   );

end tb_sample_block;

architecture tb of tb_sample_block is
   constant clk_cykle : time := 10 ns; -- set the duration of one clock cycle

   signal bit_stream_1 : std_logic := '0';
   signal bit_stream_2 : std_logic := '0';
   signal bit_stream_3 : std_logic := '0';
   signal bit_stream_4 : std_logic := '0';
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal sample_out_matrix : data_out_matrix;

   signal sim_counter : integer := 0;

   signal matrix_row_0 : std_logic_vector(23 downto 0); -- slinga 0, mic 0
   signal matrix_row_1 : std_logic_vector(23 downto 0); -- slinga 0, mic 1
   signal matrix_row_15 : std_logic_vector(23 downto 0); -- slinga 0, mic 15
   signal matrix_row_16 : std_logic_vector(23 downto 0); -- slinga 1, mic 0
   signal matrix_row_17 : std_logic_vector(23 downto 0); -- slinga 1, mic 1
   signal matrix_row_31 : std_logic_vector(23 downto 0); -- slinga 1, mic 15
   signal matrix_row_32 : std_logic_vector(23 downto 0); -- slinga 2, mic 0
   signal matrix_row_33 : std_logic_vector(23 downto 0); -- slinga 2, mic 1
   signal matrix_row_47 : std_logic_vector(23 downto 0); -- slinga 2, mic 15
   signal matrix_row_48 : std_logic_vector(23 downto 0); -- slinga 3, mic 0
   signal matrix_row_49 : std_logic_vector(23 downto 0); -- slinga 3, mic 1
   signal matrix_row_63 : std_logic_vector(23 downto 0); -- slinga 3, mic 15

   signal clk_count : integer := 0; -- counter for the number of clock cycles

   procedure clk_wait (nr_of_cykles : in integer) is
   begin
      for i in 0 to nr_of_cykles loop
         wait for clk_cykle;
      end loop;
   end procedure;

begin

   matrix_row_0 <= sample_out_matrix(0);
   matrix_row_1 <= sample_out_matrix(1);
   matrix_row_15 <= sample_out_matrix(15);
   matrix_row_16 <= sample_out_matrix(16);
   matrix_row_17 <= sample_out_matrix(17);
   matrix_row_31 <= sample_out_matrix(31);
   matrix_row_32 <= sample_out_matrix(32);
   matrix_row_33 <= sample_out_matrix(33);
   matrix_row_47 <= sample_out_matrix(47);
   matrix_row_48 <= sample_out_matrix(48);
   matrix_row_49 <= sample_out_matrix(49);
   matrix_row_63 <= sample_out_matrix(63);

   sample_block1 : entity work.sample_block port map (
      bit_stream_1 => bit_stream_1,
      bit_stream_2 => bit_stream_2,
      bit_stream_3 => bit_stream_3,
      bit_stream_4 => bit_stream_4,
      clk => clk,
      reset => reset,
      sample_out_matrix => sample_out_matrix
      );

   -- counter for clk cykles
   clk_counter : process (clk)
   begin
      if (clk = '1') then
         clk_count <= clk_count + 1;
      end if;
   end process;

   feed_data : process (clk)
   begin
      if (rising_edge(clk) and sim_counter < 5) then
         bit_stream_1 <= '0';
         bit_stream_2 <= '0';
         bit_stream_3 <= '0';
         bit_stream_4 <= '0';

         sim_counter <= sim_counter + 1;

      elsif (rising_edge(clk) and sim_counter < 10) then
         bit_stream_1 <= '1';
         bit_stream_2 <= '1';
         bit_stream_3 <= '1';
         bit_stream_4 <= '1';

         sim_counter <= sim_counter + 1;
      end if;

      if (sim_counter = 10) then
         sim_counter <= 0;
      end if;
   end process;

   clock : process
   begin
      wait for clk_cykle/2;
      clk <= not(clk);
   end process;

   main : process
   begin
      test_runner_setup(runner, runner_cfg);
      while test_suite loop
         if run("tb_sample_block_1") then -- test 1, only for gktwave

            reset <= '1';
            clk_wait(10);
            reset <= '0';

            wait for 30000 ns;
            check(1 = 1, "test_1");
         elsif run("tb_sample_block_2") then -- test 2, automatic checks after verius intervals


            check(1 = 1, "test_1");
            wait for 11 ns;

         end if;
      end loop;

      test_runner_cleanup(runner);
   end process;

   test_runner_watchdog(runner, 100 ms);
end architecture;