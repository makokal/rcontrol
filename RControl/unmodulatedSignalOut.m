function signal = unmodulatedSignalOut( freq, len )

%% ----------------------------------------------------------------------
% UNMODULATEDSIGNAL Generates the expected output
%
% freq  - Frequency (e.g 0.01)
% len   - Length of the signal
%
%% ----------------------------------------------------------------------

n = 0:len;

% signal = sin(2 * pi * freq * n);
signal = spike(1/freq, len);



end

