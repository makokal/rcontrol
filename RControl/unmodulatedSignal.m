function signal = unmodulatedSignal( freq, len, sp )

%% ----------------------------------------------------------------------
% UNMODULATEDSIGNAL Generates an unmodulated sine wave of set frequency
%
% freq  - Frequency (e.g 0.01)
% len   - Length of the signal
% sp  - probability of frequency switch
%
%% ----------------------------------------------------------------------

signal = spike(1/freq, len);

for i=1:len
    if rand < sp
        signal(i) =  0.0;
    end
end


end

