
initialRunlength    = 1000;  plotRunlength = 1000;
offset              = 4000; % time after which data from sampleinput and sampleout are used
plotStates          = [1 2 3 4]; 

totalstate      =  zeros(totalDim,1);    
internalState   = totalstate(1:netDim);
teacherPL       = zeros(outputLength, plotRunlength);
netOutPL        = zeros(outputLength, plotRunlength);
if inputLength > 0
    inputPL = zeros(inputLength, plotRunlength);
end
statePL         = zeros(length(plotStates),plotRunlength);
plotindex       = 0;
msetest         = zeros(1,outputLength); 



for i = 1:initialRunlength + plotRunlength 
    
    if inputLength > 0
        in = [diag(inputscaling) * sampleinput(:,i+offset) + inputshift];  % in is column vector  
    else in = [];
    end
    
    % remove diag
    teach = diag(teacherscaling)* sampleout(:,i+offset) + teachershift;    % teach is column vector     
    
    %write input into totalstate
    if inputLength > 0
        totalstate(netDim+1:netDim+inputLength) = in; 
    end
    %update totalstate except at input positions  
    if linearNetwork       
            internalState = ([intWM, inWM, ofbWM]*totalstate);         
    else        
            internalState = f([intWM, inWM, ofbWM]*totalstate);          
    end    
    if linearOutputUnits
        netOut = outWM *[internalState;in];
    else
        netOut = f(outWM *[internalState;in]);
    end
    totalstate = [internalState;in;netOut];    
    
    %force teacher output 
    if i <= initialRunlength 
        totalstate(netDim+inputLength+1:netDim+inputLength+outputLength) = teach; 
    end
    %update msetest
    if i > initialRunlength 
        for j = 1:outputLength
            msetest(1,j) = msetest(1,j) + (teach(j,1)- netOut(j,1))^2;
        end
    end
    
    %write plotting data into various plotfiles
    if i > initialRunlength  
        plotindex = plotindex + 1;
        if inputLength > 0
            inputPL(:,plotindex) = in;
        end
        teacherPL(:,plotindex) = teach; 
        netOutPL(:,plotindex) = netOut;
        for j = 1:length(plotStates)
            statePL(j,plotindex) = totalstate(plotStates(j),1);
        end
    end
end
%end of the great do-loop


% print diagnostics 
msetestresult = msetest / plotRunlength;
teacherVariance = var(teacherPL');;
disp(sprintf('test NRMSE = %s', num2str(sqrt(msetestresult ./ teacherVariance))));

% plot overlay of network output and teacher  
figure(5);
subplot(outputLength,1,1);   
plot(1:plotRunlength,teacherPL(1,:), 1:plotRunlength,netOutPL(1,:));
title('teacher (blue) vs. net output (green)','FontSize',8);
for k = 2:outputLength
    subplot(outputLength,1,k);
    plot(1:plotRunlength,teacherPL(k,:), 1:plotRunlength,netOutPL(k,:));
end  





