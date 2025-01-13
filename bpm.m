clc
clear all
close all

%% Load the signal and declare necessary variables

ecg=load('signal1.mat');   %comment for sample w/o ground truth
% ecg=load('test_signal_B1.mat');   %comment for sample with ground truth
sig=ecg.sig;  % sig contains the ECG sequence
BPM0=ecg.BPM0;   % BMP0 contains an array of the true BPM values of all 8 sec segments,  %comment for sample w/o ground truth

Fs = 125; % sampling frequency in Hz
window_len = 8 * Fs; % window length in samples
step_size = 2 * Fs; % step size is 2 seconds

window = sig(1+(1-1)*step_size:(1-1)*step_size+window_len);
plot(window);   

total_windows = floor((length(sig)-window_len)/step_size) + 1; 

BPMC = zeros(size(BPM0)); % array to store the calculated heart rate (BPM)  %comment for sample w/o ground truth
% BPMC=zeros(1, total_windows);     %comment for sample with ground truth

%% Generate the ecg QRS template

r=@(x) x.*[x>=0];
nf=1:7;
cf= r(nf-2)+4*r(nf-3)-16*r(nf-4)+16*r(nf-5)-5*r(nf-6);

figure;
plot(nf,cf);title('template for the ecg');

%% Main Algorithm

for i = 1 : total_windows
    START = 1+(i-1)*step_size; 
    END = (i-1)*step_size+window_len;
    curSegment = START : END ; % the samples that should go in the i'th window
    ecg_window = sig(curSegment); %the windowed signal
    [corr, lag]=xcorr(ecg_window, cf); %cross correlation
    
    % code for obtaining peaks
    thres=max(corr)/3;
    peak=0;
    for j=2: length(lag)-1
        if lag(j)>=0 
             if corr(j)>corr(j-1) && corr(j)>corr(j+1)
                  if corr(j)>thres
                       peak=peak+1; % number of R peaks in ith window
                       ind(peak)=j; % indices of R peaks
                  end
             end
        end
    end
    z=0;
    for k=1:peak-1
        z=z+ind(k+1)-ind(k);
    end
    ti = ((z+1)/(peak-1))/Fs; % average time interval in between two peaks
    bpm_calc=(1/ti)*60 ;
    BPMC(i) = bpm_calc;
end

%% Calculation of error

mean_error = mean(abs(BPMC-BPM0)) %comment for sample w/o ground truth
max_error = max(abs(BPMC-BPM0)) %comment for sample w/o ground truth

%% Plot the beats per minutes

figure;
plot(BPMC,'b');
hold on, plot(BPM0,'r');                                    %comment for sample w/o ground truth
title('Heart Rate Tracking');                               %comment for sample w/o ground truth
xlabel('Window number');                                    %comment for sample w/o ground truth
ylabel('Heart Rate (BPM)'); ylim([0, 200]);                 %comment for sample w/o ground truth
legend('Estimated Heart Rate','Ground Truth Heart Rate')    %comment for sample w/o ground truth
