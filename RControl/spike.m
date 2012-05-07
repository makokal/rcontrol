function xx = spike(p, l)
% SPIKE 
%   p - period of the signal
%   l - length of the signal

x = zeros(l,1);

    for i = 1:l
        if mod(i,p) == 0
            x(i) = 0.8;
        else
            x(i) = 0;
        end
    end
   
xx = x(:,1)';

end

% - always plot the states of the reservior network
% - when computing output weight, always compute the average output size of
%   the output weights - large means something is amiss
% - average size should be in the order of 0.something |Wout|
