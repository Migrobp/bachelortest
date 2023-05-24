runProgram();

function runProgram()
cyanImg = imread("cyan_square.jpg");
magentaImg = imread("magenta_square.jpg");
yellowImg = imread("yellow_square.jpg");
cImg = imresize(cyanImg, [720 1080]);
mImg = imresize(magentaImg, [720 1080]);
yImg = imresize(yellowImg, [720 1080]);
minXCyan = [];
maxXCyan = [];
minXMagenta = [];
maxXMagenta = [];
minXYellow = [];
maxXYellow = [];
cyanArray = [];
magentaArray = [];
yellowArray = [];

maxCyanRed = [];
maxCyanGreen = [];
maxCyanBlue = [];
maxMagentaRed = [];
maxMagentaGreen = [];
maxMagentaBlue = [];
maxYellowRed = [];
maxYellowGreen = [];
maxYellowBlue = [];

color = "blue";

divideIntoRGB("cyan", color, 16);
divideIntoRGB("magenta", color, 16);
divideIntoRGB("yellow", color, 16);

plotValues();

    function croppedImage(img, name)
        [rows, columns, ~] = size(img);
        % Crop image to right size
        croppedImg = imcrop(img, [2200 1700, 1320, 1430]);

        imwrite(croppedImg, name + "croppedImage.png");
    end

    function divideIntoRGB(cmyColor, RGBcolor, value) 
        % Read cropped image to divide it into RGB
        croppedImage = imread(cmyColor + "_square.jpg");
        [rows, columns, ~] = size(croppedImage);
        redLight = imcrop(croppedImage, [100 100 columns-50-130 rows/3-120]);
        greenLight = imcrop(croppedImage, [100 rows/3+80 columns-50-130 rows/3-130]);
        blueLight = imcrop(croppedImage, [100 rows/3*2+40 columns-50-130 rows/3-120]);
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
        sat = 255- mean(saturation);
        satCombined = sat(:,:,1) + sat(:,:,2) + sat(:,:,3)/3;
        for i = 1:values
            switch cmyColor
                case "cyan"
                    cyanArray(i) = satCombined(i);
                    switch color
                        case "red"
                            maxCyanRed = satCombined(1);
                        case "green"
                            maxCyanGreen = satCombined(1);
                        case "blue"
                            maxCyanBlue = satCombined(1);
                    end
                case "magenta"
                    magentaArray(i) = satCombined(i);
                    switch color
                        case "red"
                            maxMagentaRed = satCombined(1);
                        case "green"
                            maxMagentaGreen = satCombined(1);
                        case "blue"
                            maxMagentaBlue = satCombined(1);
                    end
                case "yellow"
                    yellowArray(i) = satCombined(i);
                    switch color
                        case "red"
                            maxYellowRed = satCombined(1);
                        case "green"
                            maxYellowGreen = satCombined(1);
                        case "blue"
                            maxYellowBlue = satCombined(1);
                    end
            end
        end
    end

    function normalArray = normalizeArray(x, cmyColor, color1)
        normalArray = [];
        switch cmyColor
            case "cyan"
                minX = minXCyan;
                switch color1
                    case "red"
                        maxX = maxCyanRed;
                    case "green"
                        maxX = maxCyanGreen;
                    case "blue"
                        maxX = maxCyanBlue;
                end
            case "magenta"
                minX = minXMagenta;
                switch color1
                    case "red"
                        maxX = maxMagentaRed;
                    case "green"
                        maxX = maxMagentaGreen;
                    case "blue"
                        maxX = maxMagentaBlue;
                end
            case "yellow"
                minX = minXYellow;
                switch color1
                    case "red"
                        maxX = maxYellowRed;
                    case "green"
                        maxX = maxYellowGreen;
                    case "blue"
                        maxX = maxYellowBlue;
                end
        end
        for i = 1:16
            normalArray(i) = (x(i)-minX)/(maxX-minX)*100
        end
    end

    function checkMinAndMax(cmyColor, croppedColor, values)
        fun = @(block_struct) mean(block_struct.data);
        saturation = blockproc(croppedColor, [1 1072/values], fun);
        sat = 255- mean(saturation);
        satCombined = sat(:,:,1) + sat(:,:,2) + sat(:,:,3)/3;
        switch cmyColor
            case "cyan"
                for i = 1:values
                    if(isempty(minXCyan))
                        minXCyan = satCombined(i);
                    end
                    if (satCombined(i) < minXCyan)
                        minXCyan = satCombined(i);
                    end
                    if(isempty(maxXCyan))
                        maxXCyan = satCombined(i);
                    end
                    if (satCombined(i) > maxXCyan)
                        maxXCyan = satCombined(i);
                    end
                end     
            case "magenta"
                for i = 1:values
                    if(isempty(minXMagenta))
                        minXMagenta = satCombined(i);
                    end
                    if (satCombined(i) < minXMagenta)
                        minXMagenta = satCombined(i);
                    end
                    if(isempty(maxXMagenta))
                        maxXMagenta = satCombined(i);
                    end
                    if (satCombined(i) > maxXMagenta)
                        maxXMagenta = satCombined(i);
                    end
                end  
            case "yellow"
                for i = 1:values
                    if(isempty(minXYellow))
                        minXYellow = satCombined(i);
                    end
                    if (satCombined(i) < minXYellow)
                        minXYellow = satCombined(i);
                    end
                    if(isempty(maxXYellow))
                        maxXYellow = satCombined(i);
                    end
                    if (satCombined(i) > maxXYellow)
                        maxXYellow = satCombined(i);
                    end
                end
        end
    end

    function plotValues()
        plot(normalizeArray(cyanArray, "cyan", color), "-o", "MarkerIndices", 1:1:length(cyanArray), "Color", "cyan")
        hold on;
        plot(normalizeArray(magentaArray, "magenta", color), "-o", "MarkerIndices", 1:1:length(magentaArray), "Color", "magenta")
        hold on;
        plot(normalizeArray(yellowArray, "yellow", color), "-o", "MarkerIndices", 1:1:length(yellowArray), "Color", "yellow")
        switch color
            case "red"
                xticklabels({"0", "", "450", "", "900", "", "1350", "", "1800"});
                %xticklabels({"0", "", "1500", "", "2100", "", "3150", "", "4200"});
            case "green"
                %xticklabels({"0", "", "750", "", "1500", "", "2250", "", "3000"});
                %xticklabels({"0", "", "1000", "", "2000", "", "3000", "", "4000"});
                xticklabels({"0", "", "375", "", "750", "", "1125", "", "1500"});
            case "blue"
                %xticklabels({"0", "", "100", "", "200", "", "300", "", "400"});
                xticklabels({"0", "", "62.5", "", "125", "", "187.5", "", "250"});
        end
        title(upper(color));
        legend("Cyan", "Magenta", "Yellow");
        hold off;
    end
end