N = 20;

y = zeros(1, N);
y(1) = 7;
er(1) = 0;
x = ones(1, 20) * 60;

for i = 1 : N - 1
  y(i + 1) = fS1(y(i), er(i));
  er(i + 1) = x(i + 1) - y(i + 1);
endfor

plot(y);
