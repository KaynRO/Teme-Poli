t = [0, pi / 6, pi / 4, pi / 3, pi / 2];
s1 = exp(1i * t);
s2 = exp(-1i * t);
ss = (s1 + s2) / 2;

plot(s1, 'ro');
hold on;
plot(s2, 'go');
hold on;
plot(ss, 'bo');
figure;

plot(real(ss), imag(ss), 'do');