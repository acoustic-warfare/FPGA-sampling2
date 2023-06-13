library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.matrix_type.all;
entity array_data is
   ------------------------------------------------------------------------------------------------------------------------------------------------
   --                                                  # port information #
   ------------------------------------------------------------------------------------------------------------------------------------------------
   generic (
      G_BITS_MIC : integer := 24; -- Defines the resulotion of a mic sample
      G_NR_MICS  : integer := 16  -- Number of chains in the Matrix
   );
   port (

      ws0        : in std_logic;
      ws1        : in std_logic;
      sck_clk0   : in std_logic;
      sck_clk1   : in std_logic;
      bit_stream : out std_logic_vector(3 downto 0)
   );
end array_data;
architecture rtl of array_data is
   type state_type is (idle, run, pause); -- three states for the state-machine. See State-diagram for more information
   signal state : state_type;

   signal paus_bit    : std_logic             := '1';
   signal ws_old      : std_logic             := '0';
   signal counter     : unsigned(31 downto 0) := (others => '0');
   signal bit_counter : integer range 0 to 31 := 0;
   signal mic_counter : integer range 0 to 15 := 0;

begin
   fill_matrix_out_p : process (sck_clk0)
   begin
      if rising_edge(sck_clk0) then

         case state is
            when idle =>
               bit_stream <= (others => '1');
               if (ws0 = '1' and ws_old = '0') then
                  state <= run;
               end if;

            when run =>
               bit_stream(0) <= counter(bit_counter);
               
               if(bit_counter = 23) then
                  state <= pause;
               end if;

               bit_counter <= bit_counter + 1;
               
            when pause  =>
               bit_stream <= (others => '1');
               if(mic_counter = 15) then
                  state <= idle;
               end if;
            
               if(bit_counter = 31) then
                  state <= run;
               end if;

            when others =>
               -- should never get here
               report("error_1");
               state <= idle;
         end case;

         ws_old <= ws0;
      end if;
   end process;
end rtl;