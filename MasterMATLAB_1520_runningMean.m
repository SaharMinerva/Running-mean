%%
%     COURSE: Master MATLAB through guided problem-solving
%    SECTION: Cleaning univariate time series
%      VIDEO: Running mean filter
% Instructor: mikexcohen.com
%
%%

% create signal
srate = 768; % Hz
time  = 0:1/srate:3;
n     = length(time);
p     = 15; % poles for random interpolation

% noise level, measured in standard deviations
noiseamp = 5; 

% amplitude modulator and noise level
ampl   = interp1(rand(1,p),linspace(1,p,n)); % use interp1 to create a p-pole time series
noise  = noiseamp * randn(size(time));% random numbers scaled by noiseamp (the noise will be randomly distributed) 
%So the assumption is that if the noise is distributed positively and negatively, the pluses and minuses
%will cancel out, resulting in a smoother function.
signal = ampl.*sin(2*pi*5*time) +noise;% ampl times sine wave plus noise 

% initialize filtered signal vector
filtsig = zeros(size(signal));

% implement the running mean filter
k = 20; % filter window is actually k*2+1
% parameter k is going to define the filter window 
for i=k+1:n-k
    % each point is the average of k surrounding points
    filtsig(i) = mean(signal(i-k:i+k));
end

% convert window size in indices to window size in ms
windowsize = 1000*(2*k+1) / srate; %this is based on a formula 


% plot the noisy and filtered signals
figure(1), clf, hold on
plot(time,signal,time,filtsig,'linew',2);

% draw a patch to indicate the window size
tidx = dsearchn(time',1); % chose #1. Where on the time vector do we have a number closest to one..the ans is index 769
ylim = get(gca,'ylim');
patch(time([tidx-k tidx-k tidx+k tidx+k]),ylim([1 2 2 1]),'k','facealpha',.25,'linestyle','none')
plot(time([tidx tidx]),ylim,'k--')

xlabel('Time (sec.)'), ylabel('Amplitude')
title([ 'Running-mean filter with a k=' num2str(round(windowsize)) '-ms filter' ])
legend({'Signal';'Filtered';'Window';'window center'})

zoom on

%%
