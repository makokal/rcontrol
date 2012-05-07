function modSig  = modulatedSignal( sig, cFreq, mIndex )

%% ------------------------------------------------------------------
%MODULATEDSIGNAL Shift modulates a given signal
%
% sig       - The unmodulated signal
% cFreq     - Frequency of the carrier signal (default sine) e.g. 0.005
% mIndex    - Modulation index (e.g 0.3)
%
%% ------------------------------------------------------------------

n = 0:length(sig)-1;
carrierSignal   = sin(2 * pi * 0.5*cFreq * n);

% modSig          = (1 + mIndex * sig).* carrierSignal;
modSig          = (mIndex * sig) + carrierSignal;

end

