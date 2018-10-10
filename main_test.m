close all
clc,clear
load('./classifer.mat')
imdsTest = imageDatastore('../VOCdevkit/VOC2007/JPEGImages','IncludeSubfolders',true);
imdsTestlabels = imageDatastore('../VOCdevkit/VOC2007/Annotations','IncludeSubfolders',true);
imageSize = [256,256];% 对所有图像进行此尺寸的缩放  
%% 预测并显示预测效果图  
index = randint(1,50,[1 3000]);  
for i = 1:length(index)
    jpgind = index(i);
    testImage = readimage(imdsTest,jpgind);
    scaleTestImage = imresize(testImage,[4500, 6500]);
    % 分成三个尺度，1000*1000 500*500  200*200
    % （6500--1000）/10=550；(4500-1000)/10=350;
    for x=1:11
        x
        for y=1:11
            x1=1+(x-1)*350;
            x2=(x-1)*350+1000;
            y1=1+(y-1)*550;
            y2=(y-1)*550+1000;
            subimage = scaleTestImage([x1:x2,y1:y2]);
            subimage = imresize(subimage, imageSize);
            featureTest = extractHOGFeatures(subimage);  
            [predictIndex,score] = predict(classifer,featureTest);  
            
            if ~isempty(find(score>=0))
                figure;imshow(scaleTestImage), rectangle('position',[y1,x1,y2-y1,x2-x1],'LineWidth',2,'edgecolor','r');
                title(['predictImage: ',char(predictIndex)]);
            end
%             pause(0.3)
%             close all
        end
    end
    % （6500--500）/30=200；(4500-500)/20=200;
    for x=1:31
        x
        for y=1:21
            x1=1+(x-1)*200;
            x2=(x-1)*200+500;
            y1=1+(y-1)*200;
            y2=(y-1)*200+500;
            subimage = scaleTestImage([x1:x2,y1:y2]);
            subimage = imresize(subimage, imageSize);
            featureTest = extractHOGFeatures(subimage);  
            [predictIndex,score] = predict(classifer,featureTest);  
            if ~isempty(find(score>=0))
                figure;imshow(scaleTestImage), rectangle('position',[y1,x1,y2-y1,x2-x1],'LineWidth',2,'edgecolor','r');
                title(['predictImage: ',char(predictIndex)]);
            end
%             pause(0.3)
%             close all
        end
    end
    % （6500-100）/100=64；(4500-100)/100=44;
    for x=1:65
        x
        for y=1:45
            x1=1+(x-1)*100;
            x2=(x-1)*100+100;
            y1=1+(y-1)*100;
            y2=(y-1)*100+100;
            subimage = scaleTestImage([x1:x2,y1:y2]);
            subimage = imresize(subimage, imageSize);
            featureTest = extractHOGFeatures(subimage);  
            [predictIndex,score] = predict(classifer,featureTest);  
            
            if ~isempty(find(score>=0))
                figure;imshow(scaleTestImage), rectangle('position',[y1,x1,y2-y1,x2-x1],'LineWidth',2,'edgecolor','r');
                title(['predictImage: ',char(predictIndex)]);
            end
%             pause(0.3)
%             close all
        end
    end
end  
