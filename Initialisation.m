clear all; 
close all;



% This script changes all interpreters from tex to latex. 

list_factory = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));

for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
    set(groot, default_name,'latex');
end



%%

SAVE = 0; 
path = 'C:\Users\milos\OneDrive\VII semestar\NM\projekat\fuzzy\izvestaj\slike\zad1';

num = [0.0004];
den = [1 0.16 0.04];
Ts = 2;

u_max = 50;
u_min = -50;

r_time = 1;
d_time = 1;

d_val = 0;
r_val = 0.4;

t_end = 4;

Kp = 1;
Kd = 1;
Tf = 1;

Ku = 1;

%%

fuzzy1_tuning;

fuzzy2_tuning;
