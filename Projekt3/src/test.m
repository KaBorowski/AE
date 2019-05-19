net = load('../data/my_net.mat');
net = net.net;
classNames = net.Layers(end).ClassNames;

inputSize = net.Layers(1).InputSize;

front = imread('../data/tests/test4.jpg');
front = imresize(front,inputSize(1:2));
[label,scores] = classify(net,front);
chance = num2str(100*scores(classNames == label),3);
figure;
imshow(front);
title(strcat(string(label), ' chance = ', num2str(chance), '%'));

