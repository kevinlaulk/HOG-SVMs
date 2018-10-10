
%% ��hog������ͼ����ж���࣬svmѵ����1 VS 1  
%% 1 ���ݼ�������ѵ���ĺͲ��Ե� (ע���Լ�ͼƬ���·������¼�Ҹ���ʾ������ͼƬ����) 
imdsTrain = imageDatastore('./screenshot',...  
    'IncludeSubfolders',true,...  
    'LabelSource','foldernames');  
imdsTest = imageDatastore('./test');  
 
 
%% ��ʾѵ����ͼƬ����Labels������Count
Train_disp = countEachLabel(imdsTrain);
disp(Train_disp);
Test_disp = countEachLabel(imdsTest);
disp(Test_disp);
  
%%   2 ��ѵ�����е�ÿ��ͼ�����hog������ȡ������ͼ��һ��  
% Ԥ����ͼ��,��Ҫ�ǵõ�features������С���˴�С��ͼ���С��Hog�����������  
imageSize = [256,256];% ������ͼ����д˳ߴ������  
image1 = readimage(imdsTrain,1);  
scaleImage = imresize(image1,imageSize);  
[features, visualization] = extractHOGFeatures(scaleImage);  
imshow(scaleImage);hold on; plot(visualization)  
  
% ������ѵ��ͼ�����������ȡ  
numImages = length(imdsTrain.Files);  
featuresTrain = zeros(numImages,size(features,2),'single'); % featuresTrainΪ������  
for i = 1:numImages  
    if mod(i,10)==0
        disp(i)
    end
    imageTrain = readimage(imdsTrain,i);  
    imageTrain = imresize(imageTrain,imageSize);  
    featuresTrain(i,:) = extractHOGFeatures(imageTrain);  
end  
  
% ����ѵ��ͼ���ǩ  
trainLabels = imdsTrain.Labels;  
  
% ��ʼsvm�����ѵ����ע�⣺fitcsvm���ڶ����࣬fitcecoc���ڶ����,1 VS 1����  
classifer = fitcecoc(featuresTrain,trainLabels);  

isLoss = resubLoss(classifer)
save('./classifer.mat','classifer')

%% Ԥ�Ⲣ��ʾԤ��Ч��ͼ  
numTest = length(imdsTest.Files);  
for i = 1:numTest  
    testImage = readimage(imdsTest,i);  
    scaleTestImage = imresize(testImage,imageSize);  
    featureTest = extractHOGFeatures(scaleTestImage);  
    [predictIndex,score] = predict(classifer,featureTest);
    if ~isempty(find(score>=0))
        figure;imshow(testImage);  
        title(['predictImage: ',char(predictIndex)]);  
    end
end  
