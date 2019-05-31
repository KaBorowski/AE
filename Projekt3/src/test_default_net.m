clear;
save = true;

net = googlenet;
classNames = net.Layers(end).ClassNames;
inputSize = net.Layers(1).InputSize;

[filename,user_canceled] = imgetfile('InitialPath', '../data/Training', 'MultiSelect',false);
if user_canceled == true
   return;
end
image = imread(filename);
image = imresize(image,inputSize(1:2));
[label,scores] = classify(net,image);
chance = num2str(100*scores(classNames == label),3);
figure;
imshow(image);
title(strcat("'",string(label),"'", " ",' Probability = '," ", num2str(chance), '%'));

if save == true
    [filepath,name,ext] = fileparts(filename);
    matlab2tikz(strcat('../data/TestNet/', name,'.tex'), 'showInfo', false);
end
