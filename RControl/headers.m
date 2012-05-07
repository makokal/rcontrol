% header infos for controller learning
clear all;
disp('Starting a new session .....................................');


%% prepare figures;
set(0, 'DefaultFigureWindowStyle', 'docked');

%% generateNet
netDim          = 50; 
connectivity    = 0.5; %0.1 
inputLength     = 1; 
outputLength    = 1;

generateNet;

%% generateTrainTestData
samplelength    = 30000;
fChangeProb     = 0.02;
signalFreq      = 0.5; %0.05; %0.1;
carrierFreq     = 0.00015; %1e-4; %0.00005; %0.007; % 0.0003
modIndex        = 0.6; %0.1; %0.3;


% samplelength    = 30000;
% fChangeProb     = 0.02;
% signalFreq      = 0.05; %0.05; %0.1;
% % signalFreq      = 4;
% carrierFreq     = 1e-4; %0.00005; %0.007; % 0.0003
% modIndex        = 0.4; %0.1; %0.3;

generateTrainTestData;


%% learnAndTest
smoothingConst      = 0.02;
controlGain         = [80 80 80 160];
specRad             = 1.0;% 1.2;%0.75; 
ofbSC               = 0; %1.0;  % output feedback scaling [1;1]
noiselevel          = 0; %1e-09; %0.00000002; 
trainNoise          = 0; %1e-05;
linearOutputUnits   = 0;  % use a sigmoid
linearNetwork       = 0; 
WienerHopf          = 0; 
initialRunlength    = 500; %15000; 
sampleRunlength     = 13000; %3000; 
freeRunlength       = 0; %1000; 
plotRunlength       = 13000;
inputscaling        = 1; %0.8; %1; 
inputshift          = 0.1; %0;
plotStates          = [1 2 3 4]; 
teacherscaling      = 1; %0.8; %1.6; 
teachershift        = 0.1; %-0.8;

trainNetwork;

%% ---
extractPCs;
findControlVectors;