N = 200;
T = 100;

input = 1:N;

r1 = ramp(N);
r2 = [zeros(1, T), r1(1:N-T)];

u1 = ustep(N);
u2 = [zeros(1, T), u1(1:N-T)];

for i = 1:N
  sum(i) = r1(i) - r2(i) - T * u2(i);
endfor

plot(input, r1, 'g-', 'LineWidth', 2);
hold on;
plot(input, -r2);
hold on;
plot(input, -T * u2);
hold on;
plot(input, sum);

