clc;
clear;
openfemm
opendocument('iter4.FEM')
main_resize(900,700)
mi_zoom(-8.5,-8.5,8.5,8.5)


n_fases=3; %Numero de fases
desfase=2*pi/(n_fases);

%Frecuencia de giro de la máquina
f_m=50;
%Frecuencia de la red, recordar que tenemos 6 pares de polos
f=f_m*6;
w=2*pi*f;
%Periodo de una vuelta
T=1/f_m;
%Resolución de la simulación
res=2;

%Ágnulos a iterar
angulos_deg=0:res:360;
tiempo_giro=(res*T/360)*angulos_deg/2;

Torque=zeros(1,length(angulos_deg));

corrientes=zeros(3,length(angulos_deg));

%Corriente peak que circula por cada bobina
I=8.66553;
%ang_desfase_corriente = 30/6;
ang_desfase_corriente = -0.117502;

for k = 1:length(angulos_deg)
    disp(k);
    if k == 1
        mi_seteditmode('group');
        mi_selectgroup(1);
        %Lo rotamos por el angulo de carga
        mi_moverotate(0,0,ang_desfase_corriente/6);
    else
        mi_seteditmode('group');
        mi_selectgroup(1);
        %Lo rotamos por el angulo de carga
        mi_moverotate(0,0,-res);
    end
    ia=-I*sin(w*tiempo_giro(k));
    ib=-I*sin(w*tiempo_giro(k)-desfase);
    ic=-I*sin(w*tiempo_giro(k)+desfase);

    corrientes(1,k)=ia;
    corrientes(2,k)=ib;
    corrientes(3,k)=ic;

    mi_setcurrent('A',ia);
    mi_setcurrent('-A',-ia);
    mi_setcurrent('B',ib);
    mi_setcurrent('-B',-ib);
    mi_setcurrent('C',ic);
    mi_setcurrent('-C',-ic);

    mi_analyze(1);
    mi_loadsolution;

    mo_seteditmode('area')
    mo_groupselectblock(1)
    T=mo_blockintegral(22);
    Torque(k)=T;
end


figure(1)
plot(angulos_deg,corrientes(1,:),'r')
hold on
grid on
plot(angulos_deg,corrientes(2,:),'b')
plot(angulos_deg,corrientes(3,:),'g')
xlabel('Ángulo mecánico del rotor [grados]')
ylabel('Corriente por fase [A]')
title('Corriente por fase en función del ángulo mecánico del rotor')
legend('Fase a', 'Fase b', 'Fase c')


figure(2)
plot(angulos_deg, Torque, 'r')
grid on
xlabel('Ángulo mecánico del rotor [grados]')
ylabel('Torque [Nm]')
title(['Torque en función del ángulo mecánico del rotor para un ángulo de' ...
    ' carga de 30º'])
T_medio= mean(Torque);

closefemm
