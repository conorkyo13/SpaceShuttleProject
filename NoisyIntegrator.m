num = 10^4
foo = randn(1,num);
hist(foo)

for i = 1:num
    bar(i) = sum(randn(1,num))/num;
end
hold on
hist(bar)

% There must be some function relating N_0 AWGN noise power to the sampling
% frequency, so that the noise measurement at the output of an integrator
% is invariant to the simulation sampling rate