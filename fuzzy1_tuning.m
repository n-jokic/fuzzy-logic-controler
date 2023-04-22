

s = tf('s');
G = tf(num, den)*exp(-Ts*s);

f = figure(1);
f.Name = 'Step_OL';
f.Renderer = 'painters';
set(findall(gcf,'-property','FontSize'),'FontSize', 8)

[y, time] = step(G);
plot(time, y, 'k');
    xlabel('$t$ [s]', 'interpreter','latex');
    ylabel('$y(t)$ [a.u.]', 'interpreter','latex');
    xlim([time(1) time(end)]);


if(SAVE)
    saveas(f,[path '\' f.Name '.eps'],'epsc');
end

t_end = time(end)*4;
r_time = 20;
d_time = 20;

Tf = 1/6;

%%

sigma = 0.4;
sigma_z = 0.45;
standard_input_range = [-1 1];
number_of_inputs = 2;
number_of_input_mfs = 3;
min_ir = min(standard_input_range);
max_ir = max(standard_input_range);
input_triang_mfs = [sigma -1 0 0; -0.8 -0.1 0.1 0.8; sigma 1 0 0 ];
stepp = (max_ir - min_ir) / (number_of_input_mfs - 1);

min_out_range = number_of_inputs * min_ir;
max_out_range = number_of_inputs * max_ir;
standard_output_range = [min_out_range, max_out_range];
output_singleton_mfs = [min_out_range: stepp: max_out_range]';


fis = sugfis('Name','rules');
fis.andMethod    = 'prod';
fis.orMethod     = 'probor';
fis.impMethod    = 'prod';
fis.aggMethod    = 'sum';
fis.defuzzMethod = 'wtsum';

fis = addInput(fis, standard_input_range, 'Name', 'e');
fis = addMF(fis, 'e', 'gaussmf', input_triang_mfs(1,:), 'Name', 'NEG');
fis = addMF(fis, 'e', "trapmf", input_triang_mfs(2,:), 'Name', 'ZERO');
fis = addMF(fis, 'e', 'gaussmf', input_triang_mfs(3,:), 'Name', 'POS');

f = figure(1); plotmf(fis,'input',1); ylabel('Stepen pripadnosti');

f.Renderer = 'painters';
f.Name = 'error_membership_fPID';

set(findall(gcf,'-property','FontSize'),'FontSize', 8)


if(SAVE)
    saveas(f,[path '\' f.Name '.eps'],'epsc');
end


fis = addInput(fis, standard_input_range, 'Name', 'ed');
fis = addMF(fis, 'ed', 'gaussmf', input_triang_mfs(1,:), 'Name', 'NEG');
fis = addMF(fis, 'ed', "trapmf", input_triang_mfs(2,:), 'Name', 'ZERO');
fis = addMF(fis, 'ed', 'gaussmf', input_triang_mfs(3,:), 'Name', 'POS');

f = figure(2); plotmf(fis,'input',2); ylabel('Stepen pripadnosti');
f.Renderer = 'painters';
f.Name = 'dif_error_membership_fPID';
set(findall(gcf,'-property','FontSize'),'FontSize', 8)

if(SAVE)
    saveas(f,[path '\' f.Name '.eps'],'epsc');
end


fis = addOutput(fis, standard_output_range, 'Name', 'u');
fis = addMF(fis, 'u', 'constant', output_singleton_mfs(1,:), 'Name', 'bNEG');
fis = addMF(fis, 'u', 'constant', output_singleton_mfs(2,:), 'Name', 'sNEG');
fis = addMF(fis, 'u', 'constant', output_singleton_mfs(3,:), 'Name', 'ZERO');
fis = addMF(fis, 'u', 'constant', output_singleton_mfs(4,:), 'Name', 'sPOS');
fis = addMF(fis, 'u', 'constant', output_singleton_mfs(5,:), 'Name', 'bPOS');


f = figure(3);
num_of_singletons = max(size(output_singleton_mfs));
stem(output_singleton_mfs, ones(num_of_singletons,1));
for i=1:num_of_singletons
    text(output_singleton_mfs(i),1.1,fis.output.MembershipFunctions(i).Name);
end

xlabel('u'); ylabel('Stepen pripadnosti'); a=axis; a(4)=1.2; axis(a);
xlim([-3, 3]);
f.Renderer = 'painters';
f.Name = 'out_fPID';set(findall(gcf,'-property','FontSize'),'FontSize', 8)

if(SAVE)
    saveas(f,[path '\' f.Name '.eps'],'epsc');
end

%Plant is not responding
rule1 = "e==NEG & ed==ZERO => u=bNEG";
rule2 = "e==POS & ed==ZERO => u=bPOS";
rule9 = "e==NEG & ed==NEG => u=bNEG";
rule10 = "e==POS & ed==POS => u=bPOS";

%Operating point
rule3 = "e==ZERO & ed==POS => u=sPOS";
rule4 = "e==ZERO & ed==NEG => u=sNEG";

%error will self correct
rule5 = "e==NEG & ed==POS => u=sNEG";
rule6 = "e==POS & ed==NEG => u=sPOS";

%no error
rule7 = "e==ZERO & ed==ZERO => u=ZERO";
rule8 = "e==ZERO & ed==ZERO => u=ZERO";




fis.Rules = [];
ruleList = [rule1 rule2 rule3 rule4 rule5 rule6 rule9 rule10];


fis = addRule(fis, ruleList);

f = figure(4); 
f.Renderer = 'painters';
f.Name = 'surf_fPID'


gensurf(fis);

if(SAVE)
    saveas(f,[path '\' f.Name '.eps'],'epsc');
end
writefis(fis,'rules');

%%
delay = 70;
t_end = 160;

sel = 1;

Tf = 1/4;
Ku = 48;
Kp = 1.12;
Kd = 12;
Ki = 11.8;



sim('.\simulink\fuzzy_model.slx');


f = figure(30);
f.Name = 'Fuzzy_input_1';
f.Renderer = 'painters';
set(findall(gcf,'-property','FontSize'),'FontSize', 8)

subplot(2, 1, 1);
    plot(time, ef, 'k');
        xlim([time(1) time(end)]);
        xlabel('$t$ [s]');
        ylabel('$e(t)$ [a.u.]');
subplot(2, 1, 2);
    plot(time, edf, 'k');
        xlim([time(1) time(end)]);
        xlabel('$t$ [s]');
        ylabel('$e_d(t)$ [a.u.]');


if(SAVE)
    saveas(f,[path '\' f.Name '.eps'],'epsc');
end


f = figure(40);
f.Name = 'output_1';
f.Renderer = 'painters';
set(findall(gcf,'-property','FontSize'),'FontSize', 8)

subplot(2, 1, 1);
    plot(time, y, 'k');
    hold on;
    p = plot(time, r, 'r--');
    hold off;
        legend(p, '$r(t)$', 'Location', 'best');
        xlim([time(1) time(end)]);
        xlabel('$t$ [s]');
        ylabel('$y(t)$ [a.u.]');
subplot(2, 1, 2);
    plot(time, u_actual, 'k');
        xlim([time(1) time(end)]);
        xlabel('$t$ [s]');
        ylabel('$u(t)$ [a.u.]');


if(SAVE)
    saveas(f,[path '\' f.Name '.eps'],'epsc');
end



