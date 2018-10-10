%2017.06.17 by masaaki
%根据Annotations 的xml 截图 JPEGImages 的jpg     ->    根据标签存放至不同文件目录

%%
clc,clear
close all
path_image='..\VOCdevkit\VOC2007\JPEGImages\';%jpg文件存放路径
path_label='..\VOCdevkit\VOC2007\Annotations\';%txt文件存放路径
path_xml='..\VOCdevkit\VOC2007\Annotations\';%xml文件存放路径
sreenshot=strcat('screenshot'); %sreenshot文件存放路径
mkdir(sreenshot);
files_all=dir([path_xml,'*.xml']);
% jpeg搜索,生成{相对路径，照片名.jpg}
upjpeg_all=dir(path_image);
upjpeg_all=upjpeg_all(4:end);
jpeg_all={};
num=1;
for i=1:length(upjpeg_all(:))
    subjpeg_all = dir([strcat(path_image,upjpeg_all(i).name,'\'),'*.jpg']);
    for j=1:length(subjpeg_all)
      jpeg_all{num}={strcat(path_image,upjpeg_all(i).name,'\',subjpeg_all(j).name),subjpeg_all(j).name(1:end-4)};
      num=num+1;
    end
end
jpeg_all1 = [jpeg_all{:}];

for j=1:length(files_all)
    
    filename=files_all(j).name
    
    % read image
    jpegname = jpeg_all1(find(ismember(jpeg_all1, filename(1:end-4)))-1)
    image = imread(jpegname{1});
    figure,imshow(image)
    hold on
    
    % read xml
    xmlDoc = strcat(path_xml, filename);
    % name node
    xmlcontent = VOCreadxml(xmlDoc);
    xmlfolder = xmlcontent.annotation.folder;
    xmlfilename = xmlcontent.annotation.filename;
    xmlpath = xmlcontent.annotation.path;
    xmlsize = xmlcontent.annotation.size;
    xmlobject = xmlcontent.annotation.object; % 需要
    
    for j = 1 : length(xmlobject)% 一个xml中的每个标签
        name = char(xmlobject(j).name);
        xmin = str2num(xmlobject(j).bndbox.xmin);
        ymin = str2num(xmlobject(j).bndbox.ymin);
        xmax = str2num(xmlobject(j).bndbox.xmax);
        ymax = str2num(xmlobject(j).bndbox.ymax);
        if exist(strcat(sreenshot,'/',name,'/'),'file')==0
            mkdir(strcat(sreenshot,'/',name,'/'))
        end
        rectangle('position',[xmin,ymin,xmax-xmin,ymax-ymin],'EdgeColor','r')
        filestring=strcat(sreenshot,'/',name,'/',filename(1:end-4),'_',name,'_',num2str(i),'.jpg');
        imwrite(image(ymin:ymax,xmin:xmax),filestring)
    end
    hold off
    pause(0.1)
    close all
end