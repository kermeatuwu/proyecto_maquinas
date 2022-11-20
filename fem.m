clc;
clear;
openfemm
opendocument('iter4.FEM')


%Corriente apagada para operación como generador en vacio
I=0;
%Número de vueltas de cada bobina
n=100;
%Datos de frecuencia en la que opereremos la máquina
frec=50;
%Periodo de una vuelta
T=1/frec;
%Resolución de la simulación
res=2;
%Tiempo que se demora en girar 'res' grados
T_ang=res*T/360;

%Ágnulos a iterar
angulos_deg=0:2:360;
tiempo_giro=T_ang*angulos_deg/2;

%Vector en el que se irá almacenando los datos del flujo a distintos
%angulos
Flujo=zeros(length(angulos_deg),9);

%Empezamos a simular el generador  distintos ángulos
for k = 1:length(angulos_deg)
    disp(k);
    %El valor de las corrientes, estarán apagadas para operación en vácio
    ia=I;
    ib=I;
    ic=I;
    %Seteamos las corrientes de los bobinados
    mi_setcurrent('A',ia);
    mi_setcurrent('-A',-ia);
    mi_setcurrent('B',ib);
    mi_setcurrent('-B',-ib);
    mi_setcurrent('C',ic);
    mi_setcurrent('-C',-ic);
    
    %Corremos la simulación en el estado actual de la máquina
    mi_analyze(1);
    mi_loadsolution;
    
    flujo=zeros(9,1);

    %Seleccionamos una sección para medir el flujo que pasa por la bobina 1
    mo_seteditmode('contour')  
    mo_selectpoint(3.23226,-0.744526);
    mo_selectpoint(3.23226,0.744526);
    %Calculamos el flujo que pasa por esta bobina
    f= mo_lineintegral(0);
    flujo(1)=f(1);
    %Seleccionamos los puntos de la bobina 2
    mo_clearcontour
    mo_selectpoint(2.95463,1.50731);
    mo_selectpoint(1.99748,2.648);
    %Calculamos el flujo que pasa por la bobina 2
    f= mo_lineintegral(0);
    flujo(2)=f(1);
    %Seleccionamos los puntos de la bobina 3
    mo_clearcontour 
    mo_selectpoint(1.29449,3.05387);
    mo_selectpoint(-0.1719,3.31244);
    %Calculamos el flujo que pasa por la bobina 3
    f= mo_lineintegral(0);
    flujo(3)=f(1);
    %Y seguimos con las 6 bobinas restantes
    %4
    mo_clearcontour 
    mo_selectpoint(-0.97135,3.17148);
    mo_selectpoint(-2.26091, 2.42695);
    f= mo_lineintegral(0);
    flujo(4)=f(1);
    %5
    mo_clearcontour 
    mo_selectpoint(-2.78269,1.80512);
    mo_selectpoint(-3.29197,0.405871);
    f= mo_lineintegral(0);
    flujo(5)=f(1);
    %6
    mo_clearcontour 
    mo_selectpoint(-3.29197,-0.405871);
    mo_selectpoint(-2.78269,-1.80512);
    f= mo_lineintegral(0);
    flujo(6)=f(1);
    %7
    mo_clearcontour 
    mo_selectpoint(-2.26091, -2.42695);
    mo_selectpoint(-0.97135,-3.17148);
    f= mo_lineintegral(0);
    flujo(7)=f(1);
    %8
    mo_clearcontour 
    mo_selectpoint(-0.17194,-3.31244);
    mo_selectpoint(1.29449,-3.05387);
    f= mo_lineintegral(0);
    flujo(8)=f(1);
    %9
    mo_clearcontour 
    mo_selectpoint(1.99748,-2.648);
    mo_selectpoint(2.95463,-1.50731);
    f= mo_lineintegral(0);
    flujo(9)=f(1);
    
    Flujo(k,:)=flujo;

    if k~=length(angulos_deg)
        mi_clearselected
        %Seleccionamos el rotor
        mo_seteditmode('group');
        mi_selectgroup(1);
        %Lo rotamos 2 grados
        mi_moverotate(0,0,-2);
    end
end

%Gráficamos el flujo que pasa por las bobinas 1, 2 y 3, sabiendo que el
%flujo de la bobina 1 debiese ser igual al de la bobina 4 y 7, el flujo que
%pasa por las bobinas de la fase A, mientras que el de la bobina 2 es la 
% fase B y la bobina 3 la fase C:
figure()
plot(angulos_deg,Flujo(:,1), 'r', angulos_deg,Flujo(:,2), 'b', angulos_deg,Flujo(:,3), 'g');
title('Flujo en las bobinas 1, 2 y 3 respecto al angulo del rotor')
xlabel('Ángulo del rotor [grados]')
ylabel('Flujo [Wb]')
legend('Bobina 1', 'Bobina 2', 'Bobina 3')
%Derivamos el flujo, cada punto esta separado en un tiempo T_ang
FEM=-n*diff(Flujo)/T_ang;
%Luego sumamos las FEM de las bobinas que componen a la fase A:
FEM_A=FEM(:,1)+FEM(:,4)+FEM(:,7);
%Lo mismo para la fase B:
FEM_B=FEM(:,2)+FEM(:,5)+FEM(:,8);
%Y la fase C:
FEM_C=FEM(:,3)+FEM(:,6)+FEM(:,9);
figure();
plot(tiempo_giro(1:end-1),FEM_A, 'r', tiempo_giro(1:end-1),FEM_B, 'b', tiempo_giro(1:end-1),FEM_C, 'g')
xlabel('Tiempo [s]')
ylabel('FEM [V]')
title('FEM generada en cada fase en una vuelta del rotor a 50Hz')
legend('Fase A', 'Fase B', 'Fase B')