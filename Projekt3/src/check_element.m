% clearvars -except net;
clear;
save = false;
net = load('../data/my_net_default3.mat');
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
for i=1:photos_count
    image = imread(filename{i});
    image = imresize(image,inputSize(1:2));
    [label,scores] = classify(net,image);
    chance = num2str(100*scores(classNames == label),3);
    element = string(label);
    subplot(col,col,i);
    imshow(image);
    title(strcat("'",element,"'", ' Probability ='," ", num2str(chance), '%'));
    clearvars -except i filename net user_canceled inputSize classNames ...
        save col photos_count
end
hold off;

if save == true
    [filepath,name,ext] = fileparts(filename{1});
    matlab2tikz(strcat('../data/Tests/', name,'.tex'), 'showInfo', false);
end


