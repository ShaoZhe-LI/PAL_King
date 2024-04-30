% =========================================================================
% INTRODUCTION
%	- Calculate the pure-tone attenuation coefficient due to the atmospheric
%       absorption based on the standard ISO 9613-1.
% -------------------------------------------------------------------------
% INPUT
%	freq		- frequency, in Hertz
% OUTPUT
%	alpha_Np	- pure-tone sound attenuation coeff. in Neper per meter, for 
%					atmospheric absorption
% =========================================================================

function alpha_Np = AbsorpAttenCoef(freq)
    % P : ambient atmospheric pressure
    P=101.325e3;
    % P_ref : reference ambient atmospheric pressure
    P_ref=101.325e3;
    % T : air temperature in Kelvins (or 273.15 + air temperature in Celsius)
    T=273.15+20;
    % T_ref : reference air temperature in Kelvins, i.e. 20 Celcius degree
    T_ref = 293.15;
    % T01 : the triple-point isotherm temperature (i.e. +0.01 Celsius degree)
    T01 = 273.16;
    humidity = 70;

    C = -6.8346*(T01./T).^1.261 + 4.6151;
    psat = P_ref .* 10.^C; % saturation vapour pressure
    % the molar concentration of water vapoupr as a percentage
    h = humidity.*(psat./P_ref).*(P./P_ref);
    % the oxygen relaxation frequency
    f_rO = P./P_ref .* (24 + 4.04*10^4 * h .* (0.02+h) ./ (0.391+h) );
    % the nitrogen relaxation frequency
    f_rN = P./P_ref .* (T./T_ref).^(-1/2) .* (9 + 280 * h .* exp(-4.17.*((T./T_ref).^(-1/3)-1)));

    alpha_Np = freq.^2 .* (1.84*10^(-11) .* P_ref./P .* (T./T_ref).^(1/2) ...
        + (T./T_ref).^(-5/2) .* (0.01275*exp(-2239.1./T)./(f_rO+freq.^2./f_rO) ...
        + 0.1068*exp(-3352.0./T)./(f_rN+freq.^2./f_rN)) );
end