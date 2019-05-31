% clearvars -except net;
clear;
save = false;
netName = 'myNet_08_02';
net = load(strcat('../data/Networks/', netName,'.mat'));
net = net.net;
classNames = net.Layers(end).ClassNames;

inputSize = net.Layers(1).InputSize;

[filename,user_canceled] = imgetfile('InitialPath', '../data/test_images', 'MultiSelect',true);
if user_canceled == true
   return;
end
figure;
hold on;
photos_count = length(filename);
col = ceil(sqrt(photos_count));
row = col;
if row*(col-1) >= photos_count
    col = col-1;
end
for i=1:photos_count
    image = imread(filename{i});
    image = imresize(image,inputSize(1:2));
    [label,scores] = classify(net,image);
    chance = num2str(100*scores(classNames == label),3);
    element = string(label);
    subplot(row,col,i);
    imshow(image);
%     title(strcat("'",element,"'", ' Probability ='," ", num2str(chance), '%'), 'FontSize', 10);
    title(strcat("'",element,"' ", num2str(chance), '%'), 'FontSize', 10);
    clearvars -except i filename net user_canceled inputSize classNames ...
        save col photos_count row netName
end
hold off;

if save == true
    matlab2tikz(strcat('../data/Tests/', netName,'.tex'), 'showInfo', false);
end


