uvImage0 = imread("uvImage0.jpg");
uvImage1 = imread("uvImage1.jpg");
uvImage2 = imread("uvImage2.jpg");
uvImage3 = imread("uvImage3.jpg");
uvImage4 = imread("uvImage4.jpg");
uvImage5 = imread("uvImage5.jpg");
uvImage6 = imread("uvImage6.jpg");
uvImage7 = imread("uvImage7.jpg");
uvImage8 = imread("uvImage8.jpg");
uvImage9 = imread("uvImage9.jpg");
uvImage10 = imread("uvImage10.jpg");
uvImage11 = imread("uvImage11.jpg");
uvImage12 = imread("uvImage12.jpg");
uvImage13 = imread("uvImage13.jpg");
uvImage14 = imread("uvImage14.jpg");
uvImage15 = imread("uvImage15.jpg");
uvImage16 = imread("uvImage16.jpg");
uvImage17 = imread("uvImage17.jpg");
uvImage18 = imread("uvImage18.jpg");
uvImage19 = imread("uvImage19.jpg");
uvImage20 = imread("uvImage20.jpg");

getSaturationAverage(uvImage0);
getSaturationAverage(uvImage1);
getSaturationAverage(uvImage2);
getSaturationAverage(uvImage3);
getSaturationAverage(uvImage4);
getSaturationAverage(uvImage5);
getSaturationAverage(uvImage6);
getSaturationAverage(uvImage7);
getSaturationAverage(uvImage8);
getSaturationAverage(uvImage9);
getSaturationAverage(uvImage10);
getSaturationAverage(uvImage11);
getSaturationAverage(uvImage12);
getSaturationAverage(uvImage13);
getSaturationAverage(uvImage14);
getSaturationAverage(uvImage15);
getSaturationAverage(uvImage16);
getSaturationAverage(uvImage17);
getSaturationAverage(uvImage18);
getSaturationAverage(uvImage19);
getSaturationAverage(uvImage20);


function getSaturationAverage(img)
% Crop image to correct size
croppedImg = imcrop(img, [2600 1400 1200 1150]);

%This one for newest 10cm
%croppedImg = imcrop(img, [2400 1450 1800 1700]);

% HSL ATTEMPT
img = rgb2hsl(croppedImg);
%lmean = mean2(double(img))


%imshow(croppedImg)
%hsvImage = rgb2hsv(croppedImg);
%grayImg = rgb2gray(croppedImg);
%imshow(grayImg)
%saturation = hsvImage(:,:,2);
%averageSat = mean(saturation(:))
%mean = mean2(croppedImg)
%mean = 255 - mean2(grayImg)
%hmean = (1 - mean2(hsvImage(:, :, 1))) * 100
%smean = mean2(hsvImage(:, :, 2)) * 100
%vmean =(1 - mean2(hsvImage(:, :, 3))) * 100
C = 255 - mean(mean(croppedImg(:,:,1)));
M = 255 - mean(mean(croppedImg(:,:,2)));
Y = 255 -  mean(mean(croppedImg(:,:,3)));
%CMY = C+M+Y
end

