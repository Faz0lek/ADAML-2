
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

clc
result = [];
%i = 1;
%j = 1;
for i = 1:10
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
            
            
            % Calculate contrast
            
            % 3rd feature
            image_contrast = double(max(I(:)) - min(I(:))); % 3
    
            features = [meanLoc, countFeatures, image_contrast,R ,G, B, i];
    
            result(end+1,:) = features;
        end
        
    end
end


%%
data = result;
save("finaldata.mat","data")
