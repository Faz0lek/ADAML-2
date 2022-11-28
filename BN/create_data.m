
%% Read images and safe to structure
imagefiles = dir('*.jpeg');      
nfiles = length(imagefiles);  

for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   currentimage = imread(currentfilename);
   images{2,ii} = currentimage;
   if ii == 406
       imshow(currentimage)
       currentfilename
   end
end
%% Extract features from data
%Dat can be loaded from images.mat

clc; clear; close all

load("images.mat")
result = [];
% i = 2;
% j = 36;
for i = 1:10
    i
    for j = 1:500
        % Detect SURF features (amount and center)
        if ndims(images{i,j}) == 3
            image = images{i,j};
            R = double(mean(image(:,:,1),"all"));
            G = double(mean(image(:,:,2),"all"));
            B = double(mean(image(:,:,3),"all"));

            I = rgb2gray(image);
        
            points = detectSURFFeatures(I);
            [~,valid_points] = extractFeatures(I,points);       
            
            % 2 first features
            meanLoc = double(mean(valid_points.Location,"all")); % 1
            countFeatures = double(valid_points.Count); % 2

            I2 = imsharpen(I);
            regions = detectMSERFeatures(I2,"MaxAreaVariation",0.05);
            res = regions(cellfun('length',regions.PixelList)<1000);
            countRegions = double(regions.Count);

%             figure; imshow(I2); hold on;
%             plot(res);

            corners = detectHarrisFeatures(I);
            [~,valid_corners] = extractFeatures(I,corners);
            countCorners = double(valid_corners.Count);
%             figure;
%             imshow(I); hold on
%             plot(valid_corners)

            % Calculate contrast
            
            % 3rd feature
            image_contrast = double(max(I(:)) - min(I(:))); % 3
    
            %features = [meanLoc, countFeatures, image_contrast,R ,G, B, i];
            features = [R ,G, B,countFeatures,countRegions, countCorners,image_contrast, meanLoc,i];
            result(end+1,:) = features;
        end
        
    end
end


%%
all_data = result;
save("all_data.mat","all_data")
