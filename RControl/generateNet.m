% 1. intWM0, sparse weight matrix of reservoir scaled to spectral radius 1, 
% 2. inWM random matrix of input-to-reservoir weights, 
% 3. ofbWM, output feedback weight matrix, 
% 4. initialOutWM all-zero initial weight matrix of reservoir-to-output units (is replaced


totalDim = netDim + inputLength + outputLength;

disp('Creating network ............');


try
    intWM0 = sprand(netDim, netDim, connectivity);
    intWM0 = spfun(@minusPoint5,intWM0);
    maxval = max(abs(eigs(intWM0,1)));
    intWM0 = intWM0/maxval;
catch e
    try
        intWM0 = sprand(netDim, netDim, connectivity);
        intWM0 = spfun(@minusPoint5,intWM0);
        maxval = max(abs(eigs(intWM0,1)));
        intWM0 = intWM0/maxval;
    catch e
        try
            intWM0 = sprand(netDim, netDim, connectivity);
            intWM0 = spfun(@minusPoint5,intWM0);
            maxval = max(abs(eigs(intWM0,1)));
            intWM0 = intWM0/maxval;
        catch e
        end
    end
end


% input weight matrix has weight vectors per input unit in colums
inWM = 2.0 * rand(netDim, inputLength)- 1.0;

% output weight matrix has weights for output units in rows
% includes weights for input-to-output connections
initialOutWM = zeros(outputLength, netDim + inputLength);

%output feedback weight matrix has weights in columns
ofbWM0 = (2.0 * rand(netDim, outputLength)- 1.0);
