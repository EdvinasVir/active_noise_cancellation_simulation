function [w, e, mse] = lmsFunct(input, numTapsFIR, numIter, mu, d)
%initialisation
e = zeros(1, numIter);
w = zeros(1, numTapsFIR);
x = zeros(1, numTapsFIR);
se = zeros(1, numIter);
mse = zeros(1, numIter);

    for i = 1 : numIter
        x = [input(i), x(1:numTapsFIR-1)]; %moving delay line
        y = sum(x .* w); %filtering process
        e(i) = d(i) - y; %error estimation
        for k = 1 : numTapsFIR
            w(k) = w(k) + (mu * e(i) * x(k)); % coefficient update equation
        end
        se(i) = (e(i)^2);   %calculate squared error
        mse(i) = mean(se(1:i)); %calculate the mean of the squared error
    end
end     

