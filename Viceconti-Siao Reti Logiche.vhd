LIBRARY ieee; 
USE ieee.std_logic_1164.ALL;

entity project_reti_logiche is                  --entity che collega i segnali di moduli 
port (
i_clk: in std_logic;
i_rst: in std_logic;
i_start: in std_logic;
i_add: in std_logic_vector(15 downto 0);
i_k: in std_logic_vector(9 downto 0);

o_done: out std_logic;

o_mem_addr: out std_logic_vector(15 downto 0);
i_mem_data: in std_logic_vector(7 downto 0);
o_mem_data: out std_logic_vector(7 downto 0);
o_mem_we: out std_logic;
o_mem_en: out std_logic
);
end project_reti_logiche;
architecture structural of project_reti_logiche is
component cella_i_reg is 
port(
i_clk: in std_logic;
i_rst: in std_logic;
zeze_cella: in std_logic;
enable_cella: in std_logic;
o_cella: out std_logic_vector(10 downto 0)
);
end component cella_i_reg;

component reg_Data is 
port(
i_clk: in STD_LOGIC;
i_rst: in STD_LOGIC;
enable_Data: in STD_LOGIC;
i_Data: in std_logic_vector(7 downto 0);
zeze_data: in std_logic;
out_x: out std_logic_vector (7 downto 0)
);
end component reg_Data;
component reg_X is 
port(
i_clk: in STD_LOGIC;
i_rst: in STD_LOGIC;
enable_x: in STD_LOGIC;
input_dadata: in std_logic_vector(7 downto 0);
zeze_x: in std_logic;
o_x: out std_logic_vector(7 downto 0)
);
end component reg_X;

component reg_Y is 
port(
i_clk: in STD_LOGIC;
i_rst: in STD_LOGIC;
enable_Y: in STD_LOGIC;
zeze_y: in std_logic;
en_cred31: in STD_LOGIC;
o_Y: out std_logic_vector(7 downto 0)
);
end component reg_Y;
component fsm is 
port(
i_clk: in std_logic;
i_rst: in std_logic;
i_start: in std_logic;
i_add: in std_logic_vector(15 downto 0);
i_k: in std_logic_vector(9 downto 0);

o_done: out std_logic;

o_mem_addr: out std_logic_vector(15 downto 0);
i_mem_data: in std_logic_vector(7 downto 0);
o_mem_data: out std_logic_vector(7 downto 0);
o_mem_we: out std_logic;
o_mem_en: out std_logic;

en_x: out std_logic;
zero_x: out std_logic;
in_X: in std_logic_vector (7 downto 0);

en_y: out std_logic;
zero_y: out std_logic;
cred31y: out std_logic;
in_Y: in std_logic_vector (7 downto 0);

en_cella: out std_logic;
zero_cella: out std_logic;
in_cella: in std_logic_vector (10 downto 0);

en_data: out std_logic;
zero_data: out std_logic;
out_data: out std_logic_vector (7 downto 0);
in_Data: in std_logic_vector (7 downto 0)
);
end component fsm;
-- segnali di collegamento
signal enen_cella, z_cella, enen_x, z_x, enen_y, z_y, credo31, enen_data, z_data : std_logic;
signal ino_cella: std_logic_vector(10 downto 0); 
signal ino_x, ino_y, outi_data, ino_data, outi_data_x: std_logic_vector (7 downto 0); 

begin -- portmap di ogni modulo
reg_cella: cella_i_reg port map(
    i_clk => i_clk,
    i_rst => i_rst,
    enable_cella => enen_cella,
    zeze_cella => z_cella,
    o_cella => ino_cella
);
x_reg: reg_X port map(
    i_rst => i_rst,
    i_clk => i_clk,
    enable_X => enen_x, 
    input_dadata => outi_data_x,
    zeze_x => z_x, 
    o_x => ino_x
);
y_reg: reg_Y port map(
    i_clk => i_clk,
    i_rst => i_rst,
    enable_Y => enen_y,
    zeze_Y=> z_y,
    en_cred31 => credo31,
    o_y => ino_Y
);
data_reg: reg_Data port map( 
    i_rst => i_rst,
    i_clk => i_clk,
    enable_Data => enen_data, 
    i_Data => outi_data, 
    zeze_data => z_data, 
    out_x => outi_data_x
);
fsm_reg: fsm port map(
    i_rst => i_rst,
    i_clk => i_clk,
    en_x => enen_x,
    zero_x => z_x,
    in_X  => ino_x,
    
    en_y  => enen_y,
    zero_y  => z_y,
    cred31y  => credo31,
    in_Y  => ino_y,
    
    en_cella  => enen_cella,
    zero_cella  => z_cella,
    in_cella  => ino_cella,
    
    en_data  => enen_data,
    zero_data  => z_data,
    out_data  => outi_data,
    in_Data  => outi_data_x,
        
    i_add => i_add,
    i_k =>  i_k,
    i_start => i_start,
    
    o_done => o_done,
    
    o_mem_addr => o_mem_addr,
    i_mem_data => i_mem_data, 
    o_mem_data => o_mem_data,
    o_mem_we => o_mem_we,
    o_mem_en => o_mem_en

);
end structural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity fsm is
port (
i_clk: in std_logic;
i_rst: in std_logic;
i_start: in std_logic;                          -- segnale di inizio di elaaborazione
i_add: in std_logic_vector(15 downto 0);        -- indirizzo dove si trova la prima parola da elaborare
i_k: in std_logic_vector(9 downto 0);           -- numero di parole da elaborare

o_done: out std_logic;                          -- segnale di fine di elaborazione

o_mem_addr: out std_logic_vector(15 downto 0);  --indirizzo a quale voglio accendere
i_mem_data: in std_logic_vector(7 downto 0);    -- dato passato da memoria
o_mem_data: out std_logic_vector(7 downto 0);   -- dato che progetto passa a memoria
o_mem_we: out std_logic;                        -- write enable, utilizzato per scrittura in memoria
o_mem_en: out std_logic;                        -- enable, utilizzato per lettura e scrittura

en_x: out std_logic;                            -- enable lavoro di x
zero_x: out std_logic;                          --inizializzazione di x
in_X: in std_logic_vector (7 downto 0);         -- input preso dal modulo X

en_y: out std_logic;                            -- enable lavoro y
zero_y: out std_logic;                          --inizializzazione di y
cred31y: out std_logic;                         -- riportare credibilità a 31 
in_Y: in std_logic_vector (7 downto 0);         --input preso dal modulo y

en_cella: out std_logic;                        -- incrementare il contatore
zero_cella: out std_logic;                      --inizializzazione di contatore cella
in_cella: in std_logic_vector (10 downto 0);    --cella manda posizione a fsm

en_data: out std_logic;                         -- enable lavoro data
zero_data: out std_logic;                       --inizializzazione di modulo Data
out_data: out std_logic_vector (7 downto 0);    --fsm passa valore a data
in_Data: in std_logic_vector (7 downto 0)       --fsm prende valore da data
);
end fsm;

architecture Behavioral of fsm is               --fsm è il elemento principale, che communica con memoria ed utilizza altri moduli
type state_type is (SAspettoStart, SInizializzazione,SReturnY, SValutFine, SLettura, SLetturaVera, SScrivoParola,SMenoCredibilita, Credibilita31, SAbbasDone);
signal next_state, current_state: state_type;
begin
state_reg: process (i_clk, i_rst)
begin  
if i_rst = '1' then                             -- controllo di i_rst
current_state <= SAspettoStart;
elsif rising_edge(i_clk) then                   --abbassamento di rst
current_state <= next_state; 
end if; 
end process;

Main: process(current_state, i_start, i_k, i_add,in_Cella,in_Data, in_x, in_y)

Begin
o_mem_en <= '0';                                -- segnali di default
o_mem_we <= '0';
o_done <= '0';	
o_mem_addr <= "0000000000000000";	
o_mem_data <= "00000000";
next_state <= current_state; 
en_x <= '0';
en_y <= '0';
en_cella <= '0';
en_Data <= '0';
zero_x <= '0';
zero_y <= '0';
zero_cella <= '0';
zero_Data <= '0';
cred31y <= '0';
out_data  <= "00000000";

Case current_state is
when SAspettoStart =>
if i_start = '0' then
	next_state<= SInizializzazione;
else
    next_state<= SAspettoStart;
end if;

when SInizializzazione =>                       --inizializzazione di moduli 	
    zero_X <= '1';
    zero_Y <= '1';
    zero_cella <= '1';
    zero_data <= '1';
    
if i_start = '1' then
	next_state <= SValutFine;
else
    next_state<= SInizializzazione;
end if;

when SValutFine =>
if in_cella = i_k&'0' then                      --quando contatore raggiunge k*2, abbiamo finito elaborazione, devo alzare o_done
    o_done <= '1';
    next_state <= SAbbasDone;
    else                                        --altrimenti fsm fa la richiesta di lettura 
    o_mem_en <= '1';
    o_mem_addr <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(in_cella) );
    next_state <= SLettura;
    end if;

when SLettura =>                                -- propagazione di dati, aspetto dati richiesti
next_state <= SLetturaVera;

when SLetturaVera =>                            -- ottengo i dati, richiedo reg_Data memorizzare la parola letta
    en_data <= '1'; 
    out_Data <= i_mem_data;
    next_state<= SScrivoParola;
    
when SScrivoParola => 
if  in_Data = "00000000" then                   -- se la parola letta sia 0, allora modifico la memoria e sovrascrivo la parola con quella precedente, che è stata salvata in reg_x
    o_mem_en <= '1';
    o_mem_we  <= '1';                           -- write enable per rescrittura della parola
	o_mem_addr <= std_logic_vector (UNSIGNED(i_add) + UNSIGNED(in_cella));
	o_mem_data <= in_X;
	en_cella <= '1';                           --aumento il contatore 
    en_Y <= '1';
	next_state <= SMenoCredibilita;
else                                           --parola letta non è 0, allora devo salvare nuova parola in reg_x
	en_X <= '1';
	en_Y <= '1';
	cred31y <= '1';
	en_cella <= '1';                           --aumento il contatore
    next_state <= Credibilita31;
end if;

When Credibilita31 =>                          --scrivo la credibilità 31
    o_mem_en <= '1';
    o_mem_we  <= '1';
    o_mem_addr<= std_logic_vector( UNSIGNED(i_add) + UNSIGNED(in_cella) );
    o_mem_data <= in_Y;
    en_cella <= '1';                           --aumento il contatore 
    next_state <= SValutFine;

When SMenoCredibilita   =>
    next_state <= SReturnY;

when SReturnY =>                               --sovrascrivo la credibilità modificata
    o_mem_en <= '1';
    o_mem_we  <= '1';
    o_mem_addr <= std_logic_vector( UNSIGNED(i_add) + UNSIGNED(in_cella));
    o_mem_data <= in_Y;
    en_cella <= '1';                            --aumento il contatore 
    next_state <= SValutFine;

when SAbbasDone =>                              --aspetto abassamento di start
    o_done <= '1';
if i_start = '0' then                           -- start è abbassato, posso tornare nello stato iniziale
    next_state <= SInizializzazione;
else
    next_state <= SAbbasDone; 
end if;

end case;
end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_X is                                 --registro X è usato per salvare la parola letta al ciclo precedente 
port(
    i_clk : in STD_LOGIC;
    i_rst : in STD_LOGIC;
    enable_X : in STD_LOGIC; 
    input_dadata: in std_logic_vector(7 downto 0); --reg Data passa un valore da salvare 
    zeze_x: in std_logic;
    
    o_x: out std_logic_vector(7 downto 0));
end reg_X;

architecture structural of reg_X is
signal X: std_logic_vector (7 downto 0);  
begin
    o_x <= X;                      
    process(i_clk, i_rst, zeze_x)
    begin
         if zeze_x = '1' or i_rst = '1' then       --inizializzazione
                X <= "00000000";
         elsif rising_edge(i_clk) then
            if enable_X = '1' then              
                if input_dadata /= "00000000" then --salvo il nuovo valore letto
                    X <= input_dadata;
                end if;
            end if;
         end if;
    end process;
end structural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity reg_Y is                                 -- modulo Y è usato per salvare la credibilita della parola precedente
port ( i_clk : in STD_LOGIC;
     i_rst : in STD_LOGIC;
     enable_Y : in STD_LOGIC;
     zeze_y: in std_logic;
     en_cred31 : in STD_LOGIC;

     o_Y : out std_logic_vector(7 downto 0));
end reg_Y;

architecture structural of reg_Y is
signal Y: std_logic_vector (7 downto 0);
begin
     o_Y <= Y;
process(i_clk, i_rst, zeze_y)
begin
     if zeze_y = '1' or i_rst = '1' then           -- inizializzazione
            Y <= "00000000";

     elsif rising_edge(i_clk) then
        if enable_Y = '1' then          
            if  en_cred31 = '1' then               --riporto il valore 31
                Y <= "00011111";
            else                                   --decremento credibilità
              if Y /= "00000000" then              -- controllo se Y è già zero 
                    Y <=  std_logic_vector(SIGNED(Y)-1);
              end if;
            end if;
        end if;
     end if;
end process;
end structural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_Data is                              -- modulo Data è usato per salvare la parola appena letta dalla memoria
port ( i_clk : in STD_LOGIC;
     i_rst : in STD_LOGIC;
     enable_Data : in STD_LOGIC; 
     i_Data : in std_logic_vector(7 downto 0); 
     zeze_data: in std_logic;

     out_x: out std_logic_vector (7 downto 0)); 
end reg_Data;

architecture structural of reg_Data is

signal Data: std_logic_vector (7 downto 0);  
begin
    out_x <= Data;                               -- passo il dato al registro x

process(i_clk, i_rst, zeze_data) 
begin
     if zeze_data = '1' or i_rst = '1' then        --inizializzazione
            Data <= "00000000";

     elsif rising_edge(i_clk) then
        if enable_Data = '1' then               --salvo il valore appena letto
            Data <= i_data;            
        end if;
     end if;
     end process;
end structural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity cella_i_reg is                           --reg cella è un contatore usato per gestione di indirizzi 
port (
    i_clk: in std_logic;
    i_rst: in std_logic;
    enable_cella: in std_logic;
    zeze_cella: in std_logic;
    
    o_cella: out std_logic_vector(10 downto 0));
end cella_i_reg;

architecture structural of cella_i_reg is
signal cella_i: std_logic_vector (10 downto 0);  

begin
    o_cella <= cella_i;
    
    process(i_clk, i_rst, zeze_cella)
begin
         if zeze_cella = '1' or i_rst = '1' then        --inizializzazione
                cella_i <= "00000000000";
         elsif rising_edge(i_clk) then       
            if enable_cella = '1' then                  -- incremento contatore
                cella_i <=  std_logic_vector( UNSIGNED(cella_i) + 1);
            end if;
         end if;
end process;
end structural;