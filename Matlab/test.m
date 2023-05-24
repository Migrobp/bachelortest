runProgram();

function runProgram()
cyanImg = imread("cyan_square.jpg");
magentaImg = imread("magenta_square.jpg");
yellowImg = imread("yellow_square.jpg");
cImg = imresize(cyanImg, [720 1080]);
mImg = imresize(magentaImg, [720 1080]);
yImg = imresize(yellowImg, [720 1080]);
minXRed = [];
maxXRed = [];
minXGreen = [];
maxXGreen = [];
minXBlue = [];
maxXBlue = [];
cyanArray = [];
magentaArray = [];
yellowArray = [];

%croppedImage(cyanImg, "cyan");
%croppedImage(magentaImg, "magenta");
%croppedImage(yellowImg, "yellow");

color = "green";

divideIntoRGB("cyan", color, 16);
divideIntoRGB("magenta", color, 16);
divideIntoRGB("yellow", color, 16);

plotValues();

function croppedImage(img, name)
[rows, columns, ~] = size(img);
% Crop image to right size
%targetSize = [rows-2000 columns-3000];
croppedImg = imcrop(img, [2200 1700, 1320, 1430]);
%rect = centerCropWindow2d(size(img), targetSize);
%croppedImg = imcrop(img, rect);

imwrite(croppedImg, name + "croppedImage.png");
end

function divideIntoRGB(cmyColor, RGBcolor, value)
% Read cropped image to divide it into RGB
croppedImage = imread(cmyColor + "_square.jpg");
[rows, columns, ~] = size(croppedImage);
redLight = imcrop(croppedImage, [100 30 columns-50-120 rows/3-50]);
greenLight = imcrop(croppedImage, [100 rows/3+80 columns-50-120 rows/3-70]);
blueLight = imcrop(croppedImage, [100 rows/3*2+40 columns-50-120 rows/3-70]);
    switch RGBcolor
        case "red"
            %imshow(redLight)
            calculateSaturation(redLight,cmyColor, value);
        case "green"
            %imshow(greenLight);
            calculateSaturation(greenLight,cmyColor, value);
        case "blue"
            %imshow(blueLight)
            calculateSaturation(blueLight,cmyColor, value);
    end
    checkMinAndMax(cmyColor, redLight, value);
    checkMinAndMax(cmyColor, greenLight, value);
    checkMinAndMax(cmyColor, blueLight, value);
end

function calculateSaturation(croppedColor, cmyColor, values)
        fun = @(block_struct) mean(block_struct.data);
        saturation = blockproc(croppedColor, [1 1072/values], fun);
        %saturation
        %mean(saturation)
        sat = 255- mean(saturation);
        %sat
        satCombined = sat(:,:,1) + sat(:,:,2) + sat(:,:,3)/3;
     for i = 1:values
        switch cmyColor
            case "cyan"
                cyanArray(i) = satCombined(i);
            case "magenta"
                magentaArray(i) = satCombined(i);
            case "yellow"
                yellowArray(i) = satCombined(i);
        end
    end
end

    function normalArray = normalizeArray(x, cmyColor) 
        normalArray = [];
        switch cmyColor
            case "red"
                minX = minXRed;
                maxX = maxXRed;
            case "green"
                minX = minXGreen;
                maxX = maxXGreen;
            case "blue"
                minX = minXBlue;
                maxX = maxXBlue;
        end
        for i = 1:16
            normalArray(i) = (x(i)-minX)/(maxX-minX)*100;
        end
    end

    function checkMinAndMax(cmyColor, croppedColor, values)
        fun = @(block_struct) mean(block_struct.data);
        saturation = blockproc(croppedColor, [1 1072/values], fun);
        %saturation
        %mean(saturation)
        sat = 255- mean(saturation);
        %sat
        satCombined = sat(:,:,1) + sat(:,:,2) + sat(:,:,3)/3;
        switch cmyColor
            case "red"
                for i = 1:values
                    if(isempty(minXRed)) 
                        minXRed = satCombined(i);
                    end 
                    if (satCombined(i) < minXRed)
                        minXRed = satCombined(i);
                    end
                    if(isempty(maxXRed)) 
                        maxXRed = satCombined(i);
                    end 
                    if (satCombined(i) > maxXRed)
                        maxXRed = satCombined(i);
                    end
                end
            case "green"
                for i = 1:values
                    if(isempty(minXGreen)) 
                        minXGreen = satCombined(i);
                    end 
                    if (satCombined(i) < minXGreen)
                        minXGreen = satCombined(i);
                    end
                    if(isempty(maxXGreen)) 
                        maxXGreen = satCombined(i);
                    end 
                    if (satCombined(i) > maxXGreen)
                        maxXGreen = satCombined(i);
                    end
                end
            case "blue"
                for i = 1:values
                    if(isempty(minXBlue)) 
                        minXBlue = satCombined(i);
                    end 
                    if (satCombined(i) < minXBlue)
                        minXBlue = satCombined(i);
                    end
                    if(isempty(maxXBlue)) 
                        maxXBlue = satCombined(i);
                    end 
                    if (satCombined(i) > maxXBlue)
                        maxXBlue = satCombined(i);
                    end
                end
        end
    end

function plotValues()
    %maxValue = max([cyanArray(1), magentaArray(1), yellowArray(1)]);
    %minValue = min([cyanArray(), magentaArray(), yellowArray()]);
    %maxValue = max([cyanArray(1)]);
    %minValue = min([cyanArray()]);
    %testPlot = interp1([minValue, maxValue], [0, 100], cyanArray);
    plot(normalizeArray(cyanArray, color), "-o", "MarkerIndices", 1:1:length(cyanArray), "Color", "cyan")
    hold on;
    plot(normalizeArray(magentaArray, color), "-o", "MarkerIndices", 1:1:length(magentaArray), "Color", "magenta")
    hold on;
    plot(normalizeArray(yellowArray, color), "-o", "MarkerIndices", 1:1:length(yellowArray), "Color", "yellow")
    %ylim([minValue maxValue]);
    %xticklabels({"0", "", "450", "", "900", "", "1350", "", "1800"});
    %yticklabels({"0", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100"});
    title(upper(color));
    legend("Cyan", "Magenta", "Yellow");
    hold off;
end
end