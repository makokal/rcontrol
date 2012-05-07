function signal = stepOscillator( len, step )

%% --------------------------------------------------------------
% STEPOSCILLATOR Binary step oscillator
% Generates a step oscillation signal
% Input
%   len  - length of the signal
%   step - the step size for the oscillation
%% --------------------------------------------------------------

% pre assignment for speed up 
signal = zeros(1,len);

for i = 1:len
    if mod(i, step) == 0
        signal(i) = 1;
    else
        signal(i) = -1;
    end
end

