library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity minutes is port(
sw : in std_logic_vector(1 downto 0);
reg_min : in std_logic;
reset : in std_logic;
one_hz : in std_logic;
three_hz : in std_logic;
minute_reached : in std_logic;
minutes_unit_segment : out std_logic_vector(3 downto 0);
minutes_decimal_segment : out std_logic_vector(3 downto 0);
hour_reached : out std_logic
);
end minutes;

architecture arch of minutes is
signal minutes_unit : std_logic_vector(3 downto 0);
signal minutes_decimal : std_logic_vector(3 downto 0);

signal clk : std_logic;
signal increment_condition : std_logic;

signal alarm_dec : std_logic_vector(3 downto 0);
signal alarm_unit : std_logic_vector(3 downto 0);

begin
process(clk, reset)
begin
	if reset = '1' then minutes_unit <= "0000"; minutes_decimal <= "0000";
	elsif rising_edge(clk) then
		if increment_condition = '1' then 
			if minutes_decimal = 5 and minutes_unit = 9 then minutes_decimal <= "0000"; minutes_unit <= "0000";
			elsif minutes_unit = 9 then minutes_decimal <= minutes_decimal + 1; minutes_unit <= "0000";
			else minutes_unit <= minutes_unit + 1;
			end if;
		end if;
	end if;
end process;

process(clk, reset)
begin
	if reset = '1' then alarm_unit <= "0000"; alarm_dec <= "0000";
	elsif rising_edge(clk) then
		if increment_condition = '1' then 
			if alarm_dec = 5 and alarm_unit = 9 then alarm_dec <= "0000"; alarm_unit <= "0000";
			elsif alarm_unit = 9 then alarm_dec <= alarm_dec + 1; alarm_unit <= "0000";
			else alarm_unit <= alarm_unit + 1;
			end if;
		end if;
	end if;
end process;

clk <= three_hz when reg_min = '0' and sw = "01" else
one_hz;

increment_condition <= '1' when reg_min = '0' and sw = "01" else
minute_reached;


minutes_unit_segment <= alarm_unit when sw = "10" else
minutes_unit;

minutes_decimal_segment <= alarm_dec when sw = "10" else
minutes_decimal;

hour_reached <= '1' when minutes_decimal = 5 and minutes_unit = 9 else
'0';
end arch;
