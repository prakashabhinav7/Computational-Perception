close all
clc;

%% Read Video
videoReader = vision.VideoFileReader('clip3.avi');  


%% Video Player
videoPlayer = vision.VideoPlayer;
fgPlayer = vision.VideoPlayer;


%% Create Foreground Detector  (Background Subtraction)
foregroundDetector = vision.ForegroundDetector('NumGaussians', 6,'NumTrainingFrames', 100);

%% Training frames
for i = 1:75
    videoFrame = step(videoReader);
    foreground = step(foregroundDetector,videoFrame);
end


%% Perform morphological operations to clean up foreground 
cleanForeground = imopen(foreground, strel('Diamond',1));

%% Create blob analysis object 

%identify cars
blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 1000, 'MaximumBlobArea', 4000);


%identify bus
blobAnalysis2 = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
     'AreaOutputPort', false, 'CentroidOutputPort', false, ...
     'MinimumBlobArea', 5500);

%identify people
blobAnalysis3 = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 500, 'MaximumBlobArea', 800);


%% Loop through video
%  a = 1;
while ~isDone(videoReader)
%     a<300
%     ~isDone(videoReader)
    %a<1250 Get the next frame
    videoFrame = step(videoReader);
    
    %Detect foreground pixels
    foreground = step(foregroundDetector,videoFrame);
    % Perform morphological filtering
    cleanForeground = imopen(foreground, strel('Disk',1));
            
    % Detect the connected components with the specified area, and
    % compute their bounding boxes
    bbox = step(blobAnalysis, cleanForeground);
    bbox2 = step(blobAnalysis2, cleanForeground);
    bbox3 = step(blobAnalysis3, cleanForeground);
    
    % Draw bounding boxes around the detected cars
%     result = insertShape(videoFrame, 'Rectangle', bbox,'Rectangle', bbox2,'Rectangle', bbox3, 'Color', 'green');

        pos   = [bbox; bbox2; bbox3];
        color = {'red', 'white', 'green'};
        result = insertShape(videoFrame, 'Rectangle', pos);


    % Display the number of cars found in the video frame
    numCars = size(bbox, 1);
    numBus = size(bbox2, 1);
    numPeeps = size(bbox3, 1);
    
    result = insertText(result, [10 10], strcat('Cars: ',num2str(numCars),' Bus: ',num2str(numBus),' Pedestrians: ',num2str(numPeeps)), 'BoxOpacity', 1, ...
        'FontSize', 14);

    % Display output 
    step(videoPlayer, result);
    step(fgPlayer,cleanForeground);

%    a=a+1;
end

%% release video reader and writer
release(videoPlayer);
release(videoReader);
release(fgPlayer);
delete(videoPlayer); % delete will cause the viewer to close
delete(fgPlayer);
