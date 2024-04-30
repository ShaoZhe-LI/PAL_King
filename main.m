clear;
tic

% =========================================================================
% Basic Parameter Settings

a=0.1;        % radius of the sound source
v0=0.12;      % vibration velocity profile constant
c=343;        % sound speed
rho=1.21;     % air density

% ultralsound frequency and audio sound frequency
fu=40e3;fa=0.5e3;
% frequency, angular frequency and wavelength of the lower ultrasound
f1=fu-fa/2;w1=2*pi*f1;la1=c/f1;
% frequency, angular frequency and wavelength of the upper ultrasound
f2=fu+fa/2;w2=2*pi*f2;la2=c/f2;
% frequency, angular frequency and wavelength of the audio sound
wa=2*pi*fa;laa=c/fa;

p00=2e-5;     % reference sound pressure
beta=1.2;     % nonlinear coefficient
delta=laa/64; % spatial discrete interval in z direction

% complex wavenumber of ultrasound and audio sound
k1=w1/c+1j*AbsorpAttenCoef(f1);
k2=w2/c+1j*AbsorpAttenCoef(f2);
ka=wa/c+1j*AbsorpAttenCoef(fa);

% =========================================================================
% FHT Parameter Settings

rho_max=2;    % upper limit of \rho direction
% truncation length
Nh=1.2*2;NH=1.2*w2/c;
N_FHT=16384;  % number of sampling points in \rho direction
n_FHT=0:N_FHT-1;

[a_solve , k0 , x1 , x0] = solve_kappa0(N_FHT , n_FHT);
% sampling points' coordinates before (xh) and after (xH) transformation in
%   \rho direction
xh=(x1*Nh).';xH=(x1*NH).';

% =========================================================================
% Velocity Function Parameter Settings

% isprofile can be defined as 'uniform' for a uniform profile or 'focus'
%   for a focusing profile
isprofile = 'uniform';
syms rho_v

% velocity function for a uniform profile
if strcmp(isprofile , 'uniform')
    vs_sym1 = v0*(heaviside(rho_v)-heaviside(rho_v-a));vs_sym2=vs_sym1;

% velocity function for a focusing profile
elseif strcmp(isprofile , 'focus')
    F=0.2;    % focal length
    vs_sym1 = v0 * exp(-1j*real(k1)*sqrt(rho_v.^2+F^2)) * ...
        (heaviside(rho_v)-heaviside(rho_v-a));
    vs_sym2 = v0 * exp(-1j*real(k2)*sqrt(rho_v.^2+F^2)) * ...
        (heaviside(rho_v)-heaviside(rho_v-a));
end

% truncation length for velocity function
Nh_v=1.1*a;NH_v=NH;
% sampling points' coordinates of the velocity functions before (xh) and
%   after (xH) transformation in \rho direction
xh_v=(x1*Nh_v).';xH_v=(x1*NH_v).';

vs_f1 = matlabFunction(vs_sym1);
% vector of velocity function of the lower ultrasound
vs1 = vs_f1(xh_v);
% vector of velocity function after transformation of the lower ultrasound
Vs1 = FHT(vs1,N_FHT,1,Nh_v,NH_v,a_solve,x0,x1,k0,0);

vs_f2 = matlabFunction(vs_sym2);
% vector of velocity function of the upper ultrasound
vs2 = vs_f2(xh_v);
% vector of velocity function after transformation of the upper ultrasound
Vs2 = FHT(vs2,N_FHT,1,Nh_v,NH_v,a_solve,x0,x1,k0,0);

% =========================================================================
% Calculation of the ultrasound field

% for ultrasound
z=0:delta:15;Nz=length(z);
% for audio sound
z_audio=0:delta:3;Nza=length(z_audio);

% ultrasound field at frequency f1
rs=sqrt(xh.^2+z.^2);
g1=exp(1j*k1*rs)./(4*pi*rs);
G1=FHT(g1,N_FHT,Nz,Nh,NH,a_solve,x0,x1,k0,0);
F1=G1.*Vs1;
phi1=-4*pi*FHT(F1,N_FHT,Nz,NH,Nh,a_solve,x0,x1,k0,0);
p1=1j*rho*c*real(k1)*phi1;p1_audio=p1(:,1:Nza);

% ultrasound field at frequency f2
g2=exp(1j*k2*rs)./(4*pi*rs);
G2=FHT(g2,N_FHT,Nz,Nh,NH,a_solve,x0,x1,k0,0);
F2=G2.*Vs2;
phi2=-4*pi*FHT(F2,N_FHT,Nz,NH,Nh,a_solve,x0,x1,k0,0);
p2=1j*rho*c*real(k2)*phi2;p2_audio=p2(:,1:Nza);

% source density of virtual source
q=conj(p1).*p2*beta*wa/(1j*rho^2*c^4);

% =========================================================================
% Calculation of the ultrasonic velocity field

% velocity field in z and \rho direction at frequency f1
vh1z=exp(1j*sqrt(k1^2-xH.^2)*z).*Vs1;
v1z=FHT(vh1z,N_FHT,Nz,NH,Nh,a_solve,x0,x1,k0,0);v1z_audio=v1z(:,1:Nza);
vh1r=G1.*Vs1.*xH;
v1r=4*pi*FHT(vh1r,N_FHT,Nz,NH,Nh,a_solve,x0,x1,k0,1);v1r_audio=v1r(:,1:Nza);

% velocity field in z and \rho direction at frequency f2
vh2z=exp(1j*sqrt(k2^2-xH.^2)*z).*Vs2;
v2z=FHT(vh2z,N_FHT,Nz,NH,Nh,a_solve,x0,x1,k0,0);v2z_audio=v2z(:,1:Nza);
vh2r=G2.*Vs2.*xH;
v2r=4*pi*FHT(vh2r,N_FHT,Nz,NH,Nh,a_solve,x0,x1,k0,1);v2r_audio=v2r(:,1:Nza);

absz=[-fliplr(z(2:end)) z];Nz1=length(absz);

% =========================================================================
% Calculation of the audio sound field

N_conv=Nz1+Nza-1;
ga=exp(1j*ka*rs)./(4*pi*rs);

Qr00=FHT(q,N_FHT,Nz,Nh,NH,a_solve,x0,x1,k0,0);
Qr0=[fliplr(Qr00(:,2:end)) Qr00];
[M_0,N_0]=size(Qr0);
Qr=[Qr0,zeros(M_0,N_conv-N_0)];
Q=(fft(Qr.')).';
Gr00=FHT(ga,N_FHT,Nz,Nh,NH,a_solve,x0,x1,k0,0);
Gr0=[fliplr(Gr00(:,2:end)) Gr00];
Gr=[Gr0,zeros(M_0,N_conv-N_0)];
G=(fft(Gr.')).';

Pa=Q.*G;
par0=(ifft(Pa.')).';
par=par0(:,N_conv-Nza+1:N_conv);
phia0=FHT(par,N_FHT,Nza,NH,Nh,a_solve,x0,x1,k0,0);
phia_W=-phia0*delta*2*pi;

% audio sound field without local effects
pa_W=1j*rho*wa*phia_W;
% audio sound field with local effects
pa_K=pa_W - (rho/2 * (conj(v1z_audio).*v2z_audio + conj(v1r_audio).*v2r_audio)...
    - (w1/w2+w2/w1-1)*conj(p1_audio).*p2_audio / (2*rho*c^2));

% =========================================================================

toc
disp(['总运行时间: ',num2str(toc)]);