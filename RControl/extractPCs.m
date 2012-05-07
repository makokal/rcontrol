%% Extract principal components from the reservior dynamics



data = stateCollectMat';
% data = internal_state;
% data = observed_state;
mu = mean(data,2);
Obar = data - repmat(mu, 1, size(data,2));
% Obar = data - repmat(mu, size(data,1),1);
m2 = mean(Obar,2);
C = Obar * Obar';
[U,S,V] = svd(C);
Po = U(:, 1:4)' * Obar;
figure(6);
plot(Po');

sigma = std(Po,0,2);


sigma_2 = sigma .^(-2);
P = diag(sigma_2) * Po;

s2 = std(P, 0, 2);
s3 = s2.^2;


% show them
% figure(6);   
% plot(P);
% plot(P(1, :));
% hold on;
% plot(P(2, :), 'r');
% plot(P(3, :), 'g');
% plot(P(4, :), 'm');

title('Principal Components (4)','FontSize',8);

%% --
% [c, vecs] = pComps(stateCollectMat', 4);

% show them
% figure(fig0);
% subplot(outputLength,1,1);   
% plot(vecs(1:100, 1));
% hold on;
% plot(vecs(1:100, 2), 'r');
% plot(vecs(1:100, 3), 'g');
% plot(vecs(1:100, 4), 'm');

% title('Principal Components (4)','FontSize',8);