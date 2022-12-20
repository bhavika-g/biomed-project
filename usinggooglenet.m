%Training and Validation using Alexnet
DatasetPath='/Users/bhavikagopalani/Downloads/physionet_ECG_data-main/ECGData/ecgdataset/';
%Reading Images from Image Database Folder
images = imageDatastore(DatasetPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
%Distributing Images in the set of Training and Testing
numTrainFiles = 250;
[TrainImages, TestImages] = splitEachLabel(images, numTrainFiles, 'randomize');
net = googlenet; %Importing pretrained Alexnet (Requires support package)
%layersTransfer = net.Layers (1:end-3);
lgraph = layerGraph(net);
numberOfLayers = numel(lgraph.Layers(1:end-3));

newDropoutLayer = dropoutLayer(0.6,'Name','new_Dropout');
lgraph = replaceLayer(lgraph,'pool5-drop_7x7_s1',newDropoutLayer);

numClasses = numel(categories(TrainImages.Labels));
newConnectedLayer = fullyConnectedLayer(numClasses,'Name','new_fc',...
    'WeightLearnRateFactor',5,'BiasLearnRateFactor',5);
lgraph = replaceLayer(lgraph,'loss3-classifier',newConnectedLayer);

newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,'output',newClassLayer);

%Training options
options=trainingOptions('sgdm', 'MiniBatchSize',20, 'MaxEpochs', 8,  'InitialLearnRate', 1e-4, 'Shuffle', 'every-epoch', 'ValidationData', TestImages, 'ValidationFrequency', 10, 'Verbose', false, 'Plots', 'training-progress');

%Training the AlexNet
netTransfer=trainNetwork(TrainImages, lgraph, options);
%Classifying Images
YPred = classify(netTransfer, TestImages);
YValidation = TestImages.Labels;
accuracy = sum(YPred == YValidation)/numel(YValidation)
%Plotting Confusion Matrix
plotconfusion(YValidation, YPred)