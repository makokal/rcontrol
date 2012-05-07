disp('Learning and testing.........');


full_state          = zeros(totalDim,1);                           % full state of the network
observed_state      = zeros(totalDim,1);
collectObserved     = [];
internal_state      = full_state(1:netDim);
W_input             = intWM0 * specRad;
W_feedback          = ofbWM0 * diag(ofbSC);
W_output            = initialOutWM;
stateCollectMat     = zeros(sampleRunlength, netDim + inputLength);
teachCollectMat     = zeros(sampleRunlength, outputLength);
teacherPL           = zeros(outputLength, plotRunlength);
netOutPL            = zeros(outputLength, plotRunlength);
if inputLength > 0
    inputPL         = zeros(inputLength, plotRunlength);
end
statePL             = zeros(length(plotStates),plotRunlength);
plotindex           = 0;
MSE_test            = zeros(1,outputLength); 
MSE_train           = zeros(1,outputLength); 


%% main loop
for i = 1:initialRunlength + sampleRunlength + freeRunlength + plotRunlength 
    
    input_signal = diag(inputscaling) * sampleinput(:,i) + inputshift;  % in is column vector  
    teacher_signal = diag(teacherscaling) * sampleout(:,i) + teachershift;    % teacher_signal is column vector     
    
    %write input into full_state adn observed state
    full_state(netDim+1:netDim+inputLength) = input_signal; 
    observed_state(netDim+1:netDim+inputLength) = input_signal; 
    
    %% update full_state except at input positions  and the the smoothed observer
    if noiselevel == 0 || noiselevel == 0.0 || i > initialRunlength + sampleRunlength
        % x(n+1) = tanh(Wx(n) + Win u(n))
        internal_state = f([W_input, inWM, W_feedback]*full_state);  

        % oberserver smoothing
        % observed_state = 0.98 * full_state + smoothingConst * internal_state;
        observed_state = smoothingConst * internal_state;
%             collectObserved = [collectObserved; observed_state' ];
    else
        internal_state = f([W_input, inWM, W_feedback]*full_state + noiselevel * 2.0 * (rand(netDim,1)-0.5));
        % internal_state = f([W_input, inWM, W_feedback]*full_state + noiselevel * 2.0 * (randn(netDim,1)));

        % oberserver smoothing
        observed_state = smoothingConst * internal_state;
%             collectObserved = [collectObserved; observed_state' ];
    end
    
  
    netOut = f(W_output *[internal_state;input_signal]);

    full_state = [internal_state;input_signal;netOut];    
    
    %% collect states and results for later use in learning procedure
    if (i > initialRunlength) && (i <= initialRunlength + sampleRunlength) 
        collectIndex = i - initialRunlength;
        stateCollectMat(collectIndex,:) = [internal_state' input_signal']; %fill a row
        
        if linearOutputUnits
            teachCollectMat(collectIndex,:) = teacher_signal';
        else
            teachCollectMat(collectIndex,:) = (fInverse(teacher_signal))'; %fill a row
        end
    end
    
    
    %% extract the PCs
%     extractPCs;
%     findControlVectors;
    
    %% deal with the control gains
%     if noiselevel == 0 || noiselevel == 0.0 || i > initialRunlength + sampleRunlength
%         internal_state = f([W_input, inWM, W_feedback]*full_state - controlGain*P'*cvecs);  
%     else
%         internal_state = f([W_input, inWM, W_feedback]*full_state + noiselevel * 2.0 * (rand(netDim,1)-0.5));
%     end
% %     
    
    %% force teacher output 
    if i <= initialRunlength + sampleRunlength
        full_state(netDim+inputLength+1:netDim+inputLength+outputLength) = teacher_signal; 
    end
    
    %% update MSE_test
    if i > initialRunlength + sampleRunlength + freeRunlength
        for j = 1:outputLength
            MSE_test(1,j) = MSE_test(1,j) + (teacher_signal(j,1)- netOut(j,1))^2;
        end
    end
    
    %% compute new model using either Wiener Hopf or Pseudoinverse
    if i == initialRunlength + sampleRunlength
        W_output = (pinv(stateCollectMat) * teachCollectMat)'; 
        
        %compute mean square errors on the training data using the newly, computed weights
        for j = 1:outputLength
            MSE_train(1,j) = sum((f(teachCollectMat(:,j)) - f(stateCollectMat * W_output(j,:)')).^2);
            MSE_train(1,j) = MSE_train(1,j) / sampleRunlength;
        end
    end
    
    %% write plotting data into various plotfiles
    if i > initialRunlength + sampleRunlength + freeRunlength 
        plotindex = plotindex + 1;
        if inputLength > 0
            inputPL(:,plotindex) = input_signal;
        end
        teacherPL(:,plotindex) = teacher_signal; 
        netOutPL(:,plotindex) = netOut;
        for j = 1:length(plotStates)
            statePL(j,plotindex) = full_state(plotStates(j),1);
        end
    end
end
%end of the great do-loop




% print diagnostics in terms of normalized RMSE (root mean square error)

msetestresult = MSE_test / plotRunlength;
teacherVariance = var(teacherPL');
disp(sprintf('train NRMSE = %s', num2str(sqrt(MSE_train ./ teacherVariance))));
disp(sprintf('test NRMSE = %s', num2str(sqrt(msetestresult ./ teacherVariance))));
disp(sprintf('average output weights = %s', num2str(mean(abs(W_output')))));


% input plot
figure(8);
subplot(inputLength,1,1);
plot(inputPL(1,:));
title('final effective inputs','FontSize',8);
for k = 2:inputLength
    subplot(inputLength,1,k);
    plot(inputPL(k,:));
end


% plot first 4 (maximally) of internal states listed in plotStates
if ~isempty(plotStates) 
    figure(3);
    subplot(2,2,1);
    plot(statePL(1,:));
    title('internal states','FontSize',8);
    for k = 2:length(plotStates)
        subplot(2,2,k);
        plot(statePL(k,:));
    end    
end

% plot weights
figure(4);
subplot(outputLength,1,1);   
plot(W_output(1,:));
title('output weights','FontSize',8);
for k = 2:outputLength
    subplot(outputLength,1,k);
    plot(W_output(k,:));
end  


% plot overlay of network output and teacher  
figure(5);
subplot(outputLength,1,1);   
plot(1:plotRunlength,teacherPL(1,:), 1:plotRunlength,netOutPL(1,:));
title('teacher (blue) vs. net output (green)','FontSize',8);
for k = 2:outputLength
    subplot(outputLength,1,k);
    plot(1:plotRunlength,teacherPL(k,:), 1:plotRunlength,netOutPL(k,:));
end  





