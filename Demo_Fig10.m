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
        clim_up = 6;
        clim_ticks = [0:6];
    case 'b'
        fa = 1e3;
        clim_up = 19;
        clim_ticks = [0:5:15 19];
    case 'c'
        fa = 2e3;
        clim_up = 55;
        clim_ticks = [0 20 40 55];
    case 'd'
        fa = 4e3;
        clim_up = 150;
        clim_ticks = [0:50:150];
    otherwise
        disp('ERROR!');
end

a = 0.5;
v0 = 0.12;
c = 343;
rho = 1.21;
beta = 1.2;
fu = 40e3;
N_FHT = 16384;
delta = 0.01;
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