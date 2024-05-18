% =========================================================================
% INTRODUCTION
%	- Demo for Fig. 9(b) in the paper
% =========================================================================

% -------------------------------------------------------------------------
% Parameter Settings

clear;

index_subfig = input('Which subfigure do you want:','s');
% input a, b, c, or d (Note: No need for quotation marks)

switch index_subfig
    case 'a'
        fa = 500;
        clim_up_all = 250;
        clim_ticks_all = [0:50:250];
        clim_up_local = 14000;
        clim_ticks_local = [0 5000 10000 14000];
    case 'b'
        fa = 1e3;
        clim_up_all = 500;
        clim_ticks_all = [0:100:500];
        clim_up_local = 14000;
        clim_ticks_local = [0 5000 10000 14000];
    case 'c'
        fa = 2e3;
        clim_up_all = 700;
        clim_ticks_all = [0:200:600 700];
        clim_up_local = 14000;
        clim_ticks_local = [0 5000 10000 14000];
    case 'd'
        fa = 4e3;
        clim_up_all = 1200;
        clim_ticks_all = [0 500 1000 1200];
        clim_up_local = 11000;
        clim_ticks_local = [0 4000 8000 11000];
    otherwise
        disp('ERROR!');
end

a = 0.5;
v0 = 0.12;
c = 343;
rho = 1.21;
beta = 1.2;
fu = 40e3;
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