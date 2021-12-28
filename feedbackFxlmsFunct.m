function [d, e, w, mse] = feedbackFxlmsFunct(input, numTaps, numIter, stepSize, wFb, wSp, wPp_sim, wFb_sim, wSp_sim)
%initialisation
d = filter(wPp_sim, 1, input(1 : numIter));
e = zeros(1, numIter); 
x = zeros(1, numTaps);
y = zeros(1, numTaps);
ySp = zeros(1, numTaps);
w = zeros(1, numTaps);
fx = zeros(1, numTaps);

    for n = 1 : numIter
       yFb = sum(wFb_sim' .* y); %calculate acoustic feedback
       xFb = input(n) + yFb; %add acoustic feedback
       yFbh = sum(wFb .* y);  %filter output using identified feedback path coeffs
       xh = xFb - yFbh; %subtract filtered output from the input
       x = [xh x(1 : numTaps - 1)];  %reference signal delay line
       fx = [sum(x .* wSp) fx(1:numTaps-1)]; %filter input signal to reduce secondary path effects
       y = [sum(x .* w) y(1 : numTaps - 1)];   %calculate the output
       ySp = [sum(y .* wSp_sim') ySp(1 : length(ySp) - 1)]; %calculate output with secondary path effects
       e(n) = d(n)' - sum(wSp_sim' .* y);  % calculate error
       for k = 1 : numTaps
           w(k) = w(k) + stepSize * e(n) * fx(k);  %update coefficients
       end
       se(n) = (e(n)^2); %calculate squared error
       mse(n) = mean(se(1:n)); %calculate mean of the squared error
    end
end

