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
        clim_up = 0.25;
        clim_ticks = [0 0.1 0.2 0.25];
    case 'b'
        a = 0.1;
        clim_up = 0.7;
        clim_ticks = [0 0.2 0.4 0.6 0.7];
    case 'c'
        a = 0.2;
        clim_up = 1.85;
        clim_ticks = [0 0.5 1 1.5 1.85];
    case 'd'
        a = 0.3;
        clim_up = 3.3;
        clim_ticks = [0 1 2 3 3.3];
    case 'e'
        a = 0.4;
        clim_up = 4.8;
        clim_ticks = [0 1 2 3 4 4.8];
    case 'f'
        a = 0.5;
        clim_up = 6;
        clim_ticks = [0 1 2 3 4 5 6];
    otherwise
        disp('ERROR!');
end

v0 = 0.12;
c = 343;
rho = 1.21;
beta = 1.2;
fu = 40e3;
fa = 0.5e3;
N_FHT = 16384;
delta = c/fa/64;
rho_max = 2;
zu_max = 15;
za_max = 8;
isprofile = 'uniform';

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

figure;
pcolor(z_audio,[fliplr(-r_audio(1:index_audio)) r_audio(1:index_audio)],...
    abs([flipud(pa_fig(1:index_audio,:));pa_fig(1:index_audio,:)]/(beta*rho*v0^2)));
colormap(MyColor('vik'));
shading interp;
clb = colorbar;
clb.Title.Interpreter = 'latex';
set(clb,'Fontsize',20);
xlim([0 max(z_audio(end),8)]);ylim([-rho_max rho_max]);
fontsize(gca,24,'points');
xlabel('$z$ (m)', 'Interpreter','latex','Fontsize',21);
ylabel('$x$ (m)', 'Interpreter','latex','Fontsize',21);
xticks([0 2 4 6 8]);yticks([-2 -1 0 1 2]);
pbaspect([z_audio(end), 2*rho_max, 1]);
set(gca, 'linewidth', 2);
set(gca, 'TickLabelInterpreter', 'latex');
clim([0,clim_up]);clb.Ticks=clim_ticks;