



load('fitLine.mat')
inputImage =255*im2double(imread('plate18.jpg'));
dim  = size(inputImage);

for j=1:dim(1) %column traverse
    for k=1:dim(2) %row traverse
        pixels(j,k,:) = [inputImage(j,k,1); inputImage(j,k,2); inputImage(j,k,3)];
    end
end

%reconstructing colorblindness representation for any value between 0 and 100
%note that we are only considering singular deficiencies whereas mixtures
%of red/green for instance would be of interest
%example of how to use:
%changes{2}(:,:,4); this command refers to all rows and columns (3x3) of
%the third degree deuteranomalous colorvision transform matrix as given in
%http://www.inf.ufrgs.br/~oliveira/pubs_files/CVD_Simulation/CVD_Simulation.html
%
%reshape(fitLine(:,41,2),3,3)'; this command retrieves the identical matrix
%
%if value 41 is changed in the reshape command to 36 we would have the
%equivalent of a 3.5 degree colorvision transform matrix
%
for y=1:10
    rgb2rgbProta(:,:,y)=reshape(fitLine(:,(10*y)+1,1),3,3)';
    rgb2rgbDeuta(:,:,y)=reshape(fitLine(:,(10*y)+1,2),3,3)';
    rgb2rgbTrita(:,:,y)=reshape(fitLine(:,(10*y)+1,3),3,3)';
end

for w=1:10    
    for j=1:dim(1)
        for k=1:dim(2)
            onePixel = [pixels(j,k,1); pixels(j,k,2); pixels(j,k,3)];
            protanomalousRGBvectors2(j,k,:)=rgb2rgbProta(:,:,w)*onePixel;
            deutanomalousRGBvectors2(j,k,:)=rgb2rgbDeuta(:,:,w)*onePixel;
            tritanomalousRGBvectors2(j,k,:)=rgb2rgbTrita(:,:,w)*onePixel;
        end
    end
    %converting back into appropriate rgb data structure
    nomalousProta{w} = uint8(protanomalousRGBvectors2);
    nomalousDeuta{w} = uint8(deutanomalousRGBvectors2);
    nomalousTrita{w} = uint8(tritanomalousRGBvectors2);    
end

inputImage = uint8(inputImage);

%outputting resulting transformed images
hold off
figure
for v=1:10    
    subplot(2,5,v)
    imshow(nomalousProta{v});
end

figure
for v=1:10    
    subplot(2,5,v)
    imshow(nomalousDeuta{v});
end

figure
for v=1:10    
    subplot(2,5,v)
    imshow(nomalousTrita{v});
end
