function signal = unmodulatedSignal( step, len, prob )

%% ----------------------------------------------------------------------
% UNMODULATEDSIGNAL Generates an unmodulated signal of set frequency and
% length
%
%   step  - step sizes for the binary oscillators
%   len   - Length of the signal
%   prob  - probability of frequency switch
%
%% ----------------------------------------------------------------------

% generate the two signals for switching
sig1 = stepOscillator(len, step(1));
sig2 = stepOscillator(len, step(2));

% preallocation for speed
signal = zeros(1,len);


% switch between the signals with a probability of prob
for i = 1:len
    if rand > prob
        signal(i) =  sig1(i);
    else
        signal(i) =  sig2(i);
    end
end


end

