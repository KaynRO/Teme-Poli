frecv1 = 1600;
frecv2 = 1800;
t = [0:0.00005:0.005];
A1 = 1;
A2 = 1;

g1 = A1 * sin(2 * pi * frecv1 * t);
g2 = A2 * sin(2 * pi * frecv2 * t);

plot(t, g1);
hold on;
plot(t, g2);
xlabel('Time (ms)');
ylabel('Value');
title('PC modem signal');
