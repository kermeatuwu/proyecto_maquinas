tmed = [-0.000183566907352978, -3.56284336198141, -6.88824100648288, -9.51995368131323,...
    -11.2684094350117, -12.1496736300861, -12.2088470963308];

angulos = [0, -15, -30, -45, -60, -75, -90];

figure()
hold on
plot(angulos,tmed, 'r')
grid on
xlabel('Ángulo de carga [grados]')
ylabel('Torque medio [Nm]')
title('Torque medio en función del ángulo de carga')