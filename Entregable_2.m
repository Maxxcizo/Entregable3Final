%% Entregable 2
% Miguel Alonso De La Rosa Zamora A01646106
clc; 
clear all;
close all;
% Condiciones iniciales
nl = 5;                 % Número de espiras
N = 20;                 % Puntos por espira
R = 1.5;                % Radio de cada espira
sz = 1;                 % Separación entre espiras
I = 300;                % Corriente (A)
mo = 4*pi*1e-7;         % Permeabilidad magnética del vacío
km = mo * I/ (4*pi);    % Constante de bio-savart
rw = 0.2;               % Grosor efectivo del alambre
plot_option = true;     % Es para hacer la grafica de los colores
ds = 0.1;
[Px, Py, Pz, dx, dy, dz] = espiras(nl, N, R, sz); % Grafica de espiras
[Bz, z] = campoS(ds, km, Px, Py, Pz, dx, dy, nl, N, rw, plot_option);

clf
plot_option = false;
ds = 0.005;
mag = 1000; % Momento magnético (valor moderado) 217 (ultima prueba)
m = 0.009;
zo = 4.9;
dt = 0.05;
vz(1) = 0.7;
gamma = 0.08;

[Bz, z] = campoS(ds, km, Px, Py, Pz, dx, dy, nl, N, rw, plot_option);
Bz = exp(-z.^2);
zm = trayectoria(Bz, z, mag, m, zo, dt, vz, gamma);
animar_con_fondo(zm, 'campo_magnetico.png', 'trayectoria_campo_magnetico.mp4');