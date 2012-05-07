%% compute the control vectors to drive the PCs to zero

% xbar = full_state(1:netDim) - mean(full_state(1:netDim));
xbar = stateCollectMat - repmat(mean(stateCollectMat), size(stateCollectMat,1),1 );

% for i = 1:4
%     pi          = P(:,i);
%     cvecs(:,i)  = mean(diag(pi) * xbar);
% end


cvecs = (P * xbar);

figure(7);
% plot the control vectors
plot(cvecs')
title('Control Vectors (4)','FontSize',8);