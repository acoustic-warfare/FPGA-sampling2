library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demo_twos_count is
   port (
      clk         : in std_logic;
      reset       : in std_logic;
      almost_full : in std_logic;
      pause       : in std_logic;
      data        : out std_logic_vector(31 downto 0) := (others => '0');
      wr_en       : out std_logic
   );
end demo_twos_count;

architecture rtl of demo_twos_count is
   signal counter_clk     : integer   := 0;
   signal counter_data    : integer   := 0;
   signal twos_complemetn : std_logic := '0';

begin

   process (clk)
   begin
      if (rising_edge(clk)) then
         wr_en <= '0';
         if (pause = '0') then
            if (counter_data = 200000000) then
               counter_data <= 0;
            end if;

            if (counter_clk = 2560 and almost_full = '0') then
               data <= std_logic_vector(to_unsigned(counter_data, data'length));
               if (twos_complemetn = '1') then
                  data(31)        <= '1';
                  twos_complemetn <= '0';
               else
                  data(31)        <= '0';
                  twos_complemetn <= '1';
               end if;

               counter_clk  <= 0;
               counter_data <= counter_data + 1;
               wr_en        <= '1';
            elsif (almost_full = '0') then
               counter_clk <= counter_clk + 1;
            end if;
         end if;
      end if;
   end process;
end rtl;