%%
r_val = 0;
d_val = 20;

delay = 90;
t_end = 180;

sel = -1;

Tf = 1/4;
Ku = 70;
Kp = 1.1;
Kd = 16;
Ki = 11;


sim('.\simulink\fuzzy_model.slx');


f = figure(30);
f.Name = 'Fuzzy_input_2';
f.Renderer = 'painters';
set(findall(gcf,'-property','FontSize'),'FontSize', 8)

subplot(2, 1, 1);
    plot(time, ef1, 'k');
        xlim([time(1) time(end)]);
        xlabel('$t$ [s]');
        ylabel('$e(t)$ [a.u.]');
subplot(2, 1, 2);
    plot(time, edf1, 'k');
        xlim([time(1) time(end)]);
        xlabel('$t$ [s]');
        ylabel('$e_d(t)$ [a.u.]');


if(SAVE)
    saveas(f,[path '\' f.Name '.eps'],'epsc');
end


f = figure(40);
f.Name = 'output_2';
f.Renderer = 'painters';
set(findall(gcf,'-property','FontSize'),'FontSize', 8)

subplot(2, 1, 1);
    plot(time, y, 'k');
        xlim([time(1) time(end)]);
        xlabel('$t$ [s]');
        ylabel('$y(t)$ [a.u.]');
subplot(2, 1, 2);
    plot(time, u_actual, 'k');
    hold on;
    p = plot(time, d, 'r--');
    hold off;
        legend(p, '$d(t)$', 'Location', 'best');
        xlim([time(1) time(end)]);
        xlabel('$t$ [s]');
        ylabel('$u(t)$ [a.u.]');


if(SAVE)
    saveas(f,[path '\' f.Name '.eps'],'epsc');
end

