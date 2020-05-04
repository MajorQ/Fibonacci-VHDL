library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Fib is
	generic ( N : integer := 4 ); -- Number of bits
	port (
	
		CLK : in std_logic;
		RST	: in std_logic := '0';
		
		Output	: out std_logic_vector(N - 1 downto 0);
		i		: out std_logic_vector(N - 1 downto 0)
	);
end Fib;

architecture Behavioral of Fib is
	
	signal X		: std_logic_vector(N - 1 downto 0) := ((N - 1 downto 1 => '0') & '1'); -- Start at 1
	signal RX		: std_logic_vector(N - 1 downto 0) := (others => '0');
	signal sum 		: std_logic_vector(N - 1 downto 0) := (others => '0');
	
	signal esum 	: std_logic;
	signal counter	: unsigned(N - 1 downto 0) := (others => '0');

begin

	process(CLK, RST)
	
		variable sum_temp	: std_logic := '0';
		variable carry		: std_logic := '0';
	
	begin
		
		if (RST = '1') then 
			
			X		<= ((N - 1 downto 1 => '0') & '1');
			RX 		<= (others => '0');
			sum 	<= (others => '0');
			counter <= (others => '0');
			
			sum_temp	:= '0';
			carry		:= '0';
		
		elsif (falling_edge(CLK)) then -- CLK'event and CLK = '1'
		
			RX	<= X;
			X	<= sum;
		
		elsif (rising_edge(CLK)) then 
			
			if (esum = '1') then
			
				-- Full Adder
				for count in 0 to N - 1 loop
				
					sum_temp 	:= X(count) xor RX(count) xor carry;
					
					carry 		:= (X(count) and RX(count)) or ((X(count) xor RX(count)) and carry);
				
					sum(count) 	<= sum_temp;
					
				end loop;
			
				counter <= counter + 1;
				
			end if;
				
		end if;
	
	end process;
	
	esum 	<= X(N - 1) nand RX(N - 1);
	
	output 	<= sum;
	i 		<= std_logic_vector(counter);
	
end Behavioral;