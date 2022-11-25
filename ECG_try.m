load('/Users/bhavikagopalani/Downloads/physionet_ECG_data-main/ECGData/ECGData.mat');
data= ECGData.Data;
labels= ECGData.Labels;

%using AlexNet (CNN)
%Transfer learning, not building a CNN from scratch

%Program to create CWT Image database from ECG signals


ARR=data(1:30, :); %Taken first 30 Recordings.
CHF=data(97:126,:);
NSR=data(127:156, :);
signallength=500;

%Defining filters for CWT with amor wavelet and 12 filters per octave
fb=cwtfilterbank('SignalLength' , signallength, 'Wavelet', 'amor', 'VoicesPerOctave',12);

%Making Folders
mkdir('/Users/bhavikagopalani/Downloads/physionet_ECG_data-main/ECGData/ecgdataset'); %Main Folder
mkdir('/Users/bhavikagopalani/Downloads/physionet_ECG_data-main/ECGData/ecgdataset/arr'); %Sub Folder
mkdir('/Users/bhavikagopalani/Downloads/physionet_ECG_data-main/ECGData/ecgdataset/chf');
mkdir('/Users/bhavikagopalani/Downloads/physionet_ECG_data-main/ECGData/ecgdataset/nsr');

ecgtype= {'ARR', 'CHF', 'NSR'};
%Function to convert ECG to Image
ecg2cwtscg(ARR, fb, ecgtype{1});
ecg2cwtscg(CHF, fb,ecgtype{2});
ecg2cwtscg(NSR, fb,ecgtype{3});

