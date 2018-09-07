%Read image
I = imread('Scanned3.jpg');
%morphological functions
se = strel('disk',1);
BW =imerode(I,se);
BW = im2bw(BW, 0.9);
%Get the boundary properties for the image
[B,L,N,A] = bwboundaries(BW);
figure; imshow(BW);



hold on;
% Loop through object boundaries
for k = 1:N
    if (nnz(A(:,k)) > 0)
        boundary = B{k};
        % Loop through the children of boundary k
        for l = find(A(:,k))'
            boundary = B{l};
            plot(boundary(:,2),...
                boundary(:,1),'r','LineWidth',2);
            
        end
    end
end
