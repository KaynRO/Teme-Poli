% Test CPA
% Author: Marios Choudary

%% Reset environment
close all;
% clear; % Only when need to clear variables
set(0, 'DefaulttextInterpreter', 'none'); % Remove TeX interpretation
tic

%% Setup the necessary paths and parameters
addpath('AES/');
data_title = 'Scores SIM DATA';
path_lab = 'lab6/';
name_data = sprintf('simdata.mat'); % Use for N=50000
% name_data = sprintf('simdata_small.mat'); % Use for N=1000
% rng('default'); % use same randomisation to get consistent results

%% Set possible candidate values
target_values = 0:255;
nr_values = length(target_values);

%% Set Hamming Weight as leakage model for each value in simulated data
lmodel = hamming_weight(target_values);

%% Load previously generated data
% 'M': vector of plaintexts
% 'X' vector of leakage traces
% 'K': key used for all traces
load(name_data);

%% Generate sbox
[s_box, ~] = s_box_gen;

%% Get number of leakage points/plaintexts
N = length(X);

%% Plot leakage data for first 1000 values
figure
idx = 1:1000;
X1 = X(idx);
plot(idx, X1);
xlabel('Sample index');
ylabel('Leakage');

%% Compute hamming weight value of S-box output for one key value
% Need (+1) in the 2 lines below due to Matlab indexing from 1
k = 1;
V = s_box(bitxor(target_values(k), M) + 1);
L = lmodel(V + 1);

%% Plot hamming weight leakage for S-box output of given key hypothesis
figure
idx = 1:1000;
L1 = L(idx);
plot(idx, L1);
xlabel('Sample index');
ylabel(sprintf('Hamming weight leakage for k=%d', k));

%% Compute correlation coefficient for this key hypothesis
c = corrcoef(X, L);
c = c(1,2);
fprintf('Correlation coefficient is: %f\n', c);

%% TODO: compute the correlation for each possible candidate
% You can initialize a vector like this:
% cv = zeros(N, 1); % column vector with N rows
for k = 1:nr_values
	V = s_box(bitxor(target_values(k), M) + 1);
	L = lmodel(V + 1);
	keys(k) = k;
  cv(k) = corrcoef(X, L)(1, 2);
end

%% TODO: plot correlation coefficient for each candidate
figure
plot(keys, cv);
xlabel('Key');
ylabel('Coef');

%% TODO: Compute success rate for different nuber of traces used in attack
% Success rate is computed as the frequency of times the correct
% key is classified first.
% For this, use variable amounts of traces (e.g. 100, 200, ..., 1000),
% and for each iteration (say 50 iterations) select that number of
% traces at random from the whole dataset
n_iter = 50;
ntraces = 100;
succ = 0;
iters = [1:n_iter];
sr = zeros(n_iter, 1);

for i=1:n_iter
	sel_idx = randperm(N, ntraces);
	Mi = M(sel_idx);
	Xi = X(sel_idx);
	
	cv = zeros(N, 1);
	keys = zeros(N, 1);
	for k = 1:nr_values
		V = s_box(bitxor(target_values(k), Mi) + 1);
		L = lmodel(V + 1);
		keys(k) = k;
		cv(k) = corrcoef(Xi, L)(1, 2);
	end

	[maxx, index] = max(cv);
	fprintf("Best key: %d\n",keys(index));

	if keys(index) == K + 1
		succ = succ + 1;
	end
  
  sr(i) = succ / i;

end

succ_rate = succ / n_iter;
fprintf("Success rate: %ld\n", succ_rate);

%% TODO: plot success rate as a function of number of traces used in attack
figure
plot(sr, iters);