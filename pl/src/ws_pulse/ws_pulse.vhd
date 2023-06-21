library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ws_pulse is
   generic (startup_length : integer := 3000000);
   port (
      sck_clk : in std_logic;
      reset   : in std_logic;
      ws      : out std_logic
   );
end ws_pulse;

architecture rtl of ws_pulse is
   signal rising_edge_counter : integer range 0 to 513 := 0;
   signal startup_counter     : unsigned (22 downto 0) := (others => '0');
begin
   ws_pulse_p : process (sck_clk)
   begin
      if (falling_edge(sck_clk)) then
         if (startup_counter > startup_length) then
            if (rising_edge_counter = 511) then
               ws                  <= '1'; -- set ws to HIGH after 509 cykles
               rising_edge_counter <= 0;
            else
               ws                  <= '0';
               rising_edge_counter <= rising_edge_counter + 1;
            end if;
         else
            ws              <= '0';
            startup_counter <= startup_counter + 1;
         end if;

         if (reset = '1') then
            ws                  <= '0';
            startup_counter     <= (others => '0');
            rising_edge_counter <= 0;
         end if;
      end if;
   end process;

end rtl;