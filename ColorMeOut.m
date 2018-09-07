%Read in the image
im = imread('SudokuGrid3.jpg');

%Convert to black and white and invert
im = imclearborder(im2bw(im, 0.9));
imc = imcomplement(im);

%Defining Structuring Elements
se=strel('line',1, 45);
se1=strel('line',1 ,135);

%Morphological functions
imd = imdilate(imc,se);
imd1 = imdilate(imd,se1);
%inverting the image
imc2 = imcomplement(imd1);

%Get the BW labels and re-label using RGB
[labelled,num]= bwlabel(imc2);
final=label2rgb(labelled, 'hsv');
imshow(final);
