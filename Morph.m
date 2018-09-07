%Read in the image
im = imread('warmup.jpg');

%Create 2 versions: black and white and Grayscale
bw = im2bw(im, 0.5);
gs = rgb2gray(im);

%Get grid-only output
c = imfill(gs);
figure, imshow(c); 

%Convert grid-only output to BW
d = im2bw(c, 0.5);

%Subtract the grid from grid+numbers to get numbers only
e = d-bw;

%Invert back the image
e = ~e;
figure, imshow(e);
