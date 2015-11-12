function [alpha, alpha_iso, c, c_iso]=air_absorption(f, T, hr, ps)
% % air_absorption: Calculates sound absorption (attenuation) in humid air   
% % 
% % Syntax:
% % 
% % [alpha, alpha_iso, c, c_iso]=air_absorption(f, T, hr, ps);
% %
% % **********************************************************************
% % 
% % Description
% % 
% % Calculates sound absorption (attenuation) in humid air using the ISO
% % standard and the Bass forumla.  
% % 
% % See appropriate input and output variables sections below for
% % more details. 
% % 
% % 
% % **********************************************************************
% %
% % Input Variables
% % 
% % f=100;      % (Hz) frequency of pure tone
% %             % default is f=100;
% %
% % T=25;       % (degrees Celsius) temperature
% %             % default is T=25;
% % 
% % hr=50;      % (Percent) Relative Humidity 
% %             % default is hr=50;
% % 
% % ps=1;       % atmospheric pressure ratio
% %             % pa/pr ratio of ambient aatmospoheric pressure to the
% %             % standard atmosphere.  
% %             % default is ps=1;
% % 
% % **********************************************************************
% %
% % Output Variables
% % 
% % alpha       sound absorption is (dB/meter) according to Bass
% % 
% % alpha_iso   sound absorption is (dB/meter) according to ISO standard
% % 
% % c           speed of sound in humid air (meters/second) according to
% %             Bass
% % 
% % c_iso       speed of sound in humid air (meters/second) according to 
% %             ISO standard
% % 
% % **********************************************************************
% 
% Example='1';
% 
% 
% f=100;   % frequency  in Hz
%
% T=20;    % 20 Degrees Celsius
%
% hr=80;   % Relative humidity in percentage hr=80 means 80 percent humidity
%          
% ps=1;    % Is the barometric pressure ratio. Usually, ps=1;
% 
% % Run the program
% [alpha, alpha_iso, c, c_iso]=air_absorption(f, T, hr, ps);
% 
% 
% 
% % **********************************************************************
% %
% % This program was  Written by Edward L. Zechmann   
% % 
% % date        September   2006  
% % 
% % modified    March       2010    Updated Comments chnged input units of
% %                                 T from Farhenheit to Celsius.
% % 
% % **********************************************************************
% % 
% %
% % Please Feel Free to Modify This Program
% %
% % See Also: Atmosphere (its on the Matlab file exchange)
% %

if nargin < 1 || isempty(f) || ~isnumeric(f)
    f=100;
end

if nargin < 2 || isempty(T) || ~isnumeric(T)
    T=25;
end

if nargin < 3 || isempty(hr) || ~isnumeric(hr)
    hr=50;
end

if nargin < 4 || isempty(ps) || ~isnumeric(ps)
    ps=1;
end

hr=hr/100;

% convert T from Celsius to Kelvin;
%T=273.15+5/9*(T-32); to convert from Farhenheit
T=273.15+T; % To convert from Celsius

% listing of constants

T01=273.16; %triple point in degrees Kelvin
T0=293.15;
% atmospheric pressure ratio is the ambient pressure/standard pressure
ps0=1;  % ps0= standard pressure/standard pressure which is unity

% Bass formula for saturation pressure ratio
psat_ps0=10^( 10.79586*(1-T01/T) -5.02808*log10(T/T01) +1.50474*10^(-4)*(1-10^(-8.29692*(T/T01-1))) -4.2873*10^(-4)*(1-10^(-4.76955*(T01/T-1)))-2.2195983);

% Iso formula for saturation pressure ratio
psat_ps0_iso=10^( -6.8346*(T01/T)^1.261+4.6151);

ps_ps0=ps/ps0;

h = hr*psat_ps0/ps_ps0; % h is the humidity in percent molar concentration
h_iso = hr*psat_ps0_iso/ps_ps0; % h is the humidity in percent molar concentration

c0 = 331; % c0 is the reference sound speed
c = (1+0.16*h)*c0*sqrt(T/T01);
c_iso = (1+0.16*h_iso)*c0*sqrt(T/T01);

% % 
% % **********************************************************************
%  
% 
% Bass formula

F=f/ps;

Fr0=1/ps0*(24+4.04*10^4*h*(0.02+h)/(0.391+h));
FrN=1/ps0*(T0/T)^(1/2)*(9+280*h*exp(-4.17*((T0/T)^(1/3)-1)));

% Calculate the air absorption in dB/meter using the Bass formula
alpha=20*log10(exp(1))*ps*F^2*( 1.84*10^(-11)*(T/T0)^(0.5)*ps0+((T/T0)^(-5/2))*( 0.01275*exp(-2239.1/T)/(Fr0+F^2/Fr0)+0.1068*exp(-3352/T)/(FrN+F^2/FrN) ));



% % 
% % **********************************************************************
%  
% 
%ISO formula

taur=T/T0;
pr=ps/ps0;

fr0=pr*(24+40400*h_iso*(0.02+h_iso)/(0.391+h_iso));
frN=pr*(taur)^(-1/2)*(9+280*h_iso*exp(-4.17*((taur)^(-1/3)-1)));

b1=0.1068*exp(-3352/T)/(frN+f^2/frN);
b2=0.01275*exp(-2239.1/T)/(fr0+f^2/fr0);

% Calculate the air absorption in dB/meter for the ISO standard
alpha_iso=8.686*f^2*taur^(1/2)*(1.84*10^(-11)/pr+taur^(-3)*(b1+b2));

