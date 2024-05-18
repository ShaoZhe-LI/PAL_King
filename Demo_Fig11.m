% =========================================================================
% INTRODUCTION
%	- Demo for Fig. 9(b) in the paper
% =========================================================================

% -------------------------------------------------------------------------
% Parameter Settings

clear;

index_subfig = input('Which subfigure do you want:','s');
% input a, b, c, d, e, or f (Note: No need for quotation marks)

switch index_subfig
    case 'a'
        a = 0.05;
        clim_up_all = 0.8;
        clim_ticks_all = [0:0.2:0.8];
        clim_up_local = 0.4;
        clim_ticks_local = [0:0.2:0.4];
    case 'b'
        a = 0.1;
        clim_up_all = 3;
        clim_ticks_all = [0:1:3];
        clim_up_local = 13;
        clim_ticks_local = [0 5 10 13];
    case 'c'
        a = 0.2;
        clim_up_all = 20;
        clim_ticks_all = [0:5:20];
        clim_up_local = 400;
        clim_ticks_local = [0:200:400];
    case 'd'
        a = 0.3;
        clim_up_all = 60;
        clim_ticks_all = [0:20:60];
        clim_up_local = 2500;
        clim_ticks_local = [0 1000 2000 2500];
    case 'e'
        a = 0.4;
        clim_up_all = 120;
        clim_ticks_all = [0:20:120];
        clim_up_local = 6700;
        clim_ticks_local = [0 2500 5000 6700];
    case 'f'
        a = 0.5;
        clim_up_all = 250;
        clim_ticks_all = [0:50:250];
        clim_up_local = 14000;
        clim_ticks_local = [0 5000 10000 14000];
    otherwise
        disp('ERROR!');
end

v0 = 0.12;
c = 343;
rho = 1.21;
beta = 1.2;
fu = 40e3;
fa = 0.5e3;
N_FHT = 32768;
delta = 0.005;
rho_max = 0.8;
zu_max = 10;
za_max = 1.6;
isprofile = 'focus';

% -------------------------------------------------------------------------
% Audio Sound Field Calculation

tic
[xh, z_audio, pa_W, pa_K] = PAL_King(a, v0, c, rho, beta, fu, fa, N_FHT, ...
    delta, rho_max, zu_max, za_max, isprofile);
toc

% -------------------------------------------------------------------------
% Draw Figures

r_audio=(xh(1:8:end)).';
[~,index_audio]=min(abs(r_audio-rho_max));
if r_audio(index_audio)<rho_max
    index_audio=index_audio+1;
end
pa_fig=pa_K(1:8:end,:);

figure('name', 'all');
pcolor(z_audio,[fliplr(-r_audio(1:index_audio)) r_audio(1:index_audio)],...
    abs([flipud(pa_fig(1:index_audio,:));pa_fig(1:index_audio,:)]/(beta*rho*v0^2)));
colormap(MyColor('vik'));
shading interp;
clb = colorbar;
clb.Title.Interpreter = 'latex';
set(clb,'Fontsize',20);
xlim([0 max(z_audio(end),1.6)]);ylim([-rho_max rho_max]);
fontsize(gca,24,'points');
xlabel('$z$ (m)', 'Interpreter','latex','Fontsize',21);
ylabel('$x$ (m)', 'Interpreter','latex','Fontsize',21);
xticks([0 0.5 1 1.5]);yticks([-0.8 -0.5 0 0.5 0.8]);
pbaspect([z_audio(end), 2*rho_max, 1]);
set(gca, 'linewidth', 2);
set(gca, 'TickLabelInterpreter', 'latex');
clim([0,clim_up_all]);clb.Ticks=clim_ticks_all;

figure('name', 'local');
rrind=2183;
z_min=31;z_max=51;
pcolor(z_audio(z_min:z_max),[fliplr(-r_audio(1:rrind)) r_audio(1:rrind)],(abs([flipud(pa_fig(1:rrind,z_min:z_max));pa_fig(1:rrind,z_min:z_max)]/(beta*rho*v0^2))));
ac=gca;
colormap(MyColor('vik'));
shading interp;
clb = colorbar;
clb.Title.Interpreter = 'latex';
set(clb,'Fontsize',25);
xlim([0.15 0.25]);ylim([-0.02 0.02]);
fontsize(gca,30,'points');
xticks([0.15 0.2 0.25]);yticks([-0.02 0 0.02]);
pbaspect([10, 4, 1]);
set(gca, 'linewidth', 1.5);
set(gca, 'TickLabelInterpreter', 'latex');
clim([0,clim_up_local]);clb.Ticks=clim_ticks_local;