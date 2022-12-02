clc;
clear;
openfemm
opendocument('iter4.FEM')
main_resize(900,700)

%Corriente peak que circula por cada bobina
I=8.67;
n_fases=3; %Numero de fases
desfase=2*pi/(n_fases);

%N de vueltas de cada bobina
n=100;
%Frecuencia de giro de la máquina
f_m=50;
%Frecuencia de la red, recordar que tenemos 6 pares de polos
f=50*6;
w=2*pi*f;
%Periodo de una vuelta
T=1/f_m;
%Resolución de la simulación
res=2;

%Ágnulos a iterar
angulos_deg=0:res:360;
tiempo_giro=(res*T/360)*angulos_deg/2;

%ang_desfase_corriente = 30/6;
ang_desfase_corriente = 0.1175/6;

for k = 1:length(angulos_deg)
    disp(k);
    if k == 1 
        mi_seteditmode('group');
        mi_selectgroup(1);
        %Lo rotamos por el angulo de carga
        mi_moverotate(0,0,-ang_desfase_corriente);
    else
        mi_seteditmode('group');
        mi_selectgroup(1);
        %Lo rotamos por el angulo de carga
        mi_moverotate(0,0,-res);
    end
    ia=I*sin(w*tiempo_giro(k));
    ib=I*sin(w*tiempo_giro(k)-desfase);
    ic=I*sin(w*tiempo_giro(k)+desfase);

    mi_setcurrent('A',ia);
    mi_setcurrent('-A',-ia);
    mi_setcurrent('B',ib);
    mi_setcurrent('-B',-ib);
    mi_setcurrent('C',ic);
    mi_setcurrent('-C',-ic);

    mi_analyze(1);
    mi_loadsolution;
    mo_zoom(-8.5,-8.5,8.5,8.5)
    mo_hidepoints;
    mo_showvectorplot(1,1);
    mo_showdensityplot(1,0,1.5,0,'mag');

    mo_savebitmap(['Animacion/frame', num2str(k), '.bmp']);

    mo_hidedensityplot;
    mo_showvectorplot(0,1);

end