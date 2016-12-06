inputImage =255*im2double(imread('chamdeut.jpg'));
dim  = size(inputImage);

%%#1 omitted image already in rgb format
%%need to obtain i j k values 
% %shift ijk to rgb values

% TESTING INDIVIDUAL POINTS TO TABLE II
%I = 102;
%J = 153;
%K = 204;
%R = (I./255)^2.2; %R
%G = (J./255)^2.2; %G
%B = (K./255)^2.2; %B
%inputImage(1,1,1) = R;
%inputImage(1,1,2) = G;
%inputImage(1,1,3) = B;
%dim  = size(inputImage);

%#2 Color Reduction
%For protanopes and deuteranopes:

%slight color domain reduction of orginal palette
for i=1:3
    protaNOPE(:,:,i) = (0.992052.*inputImage(:,:,i)) + 0.003974;
    deuteraNOPE(:,:,i) = (0.957237.*inputImage(:,:,i)) + 0.0213814;
end

%protaNOPE = inputImage;
%deuteraNOPE = inputImage;


%#3 xy shifts from chromaticity scale I think are what give the RGB to XYZ 
%transform values which are combined with the XYZ to LMS values and used 
%in the rgb2lms transform below

rgb2lms(1,:)=[17.8824 43.5161 4.11935];
rgb2lms(2,:)=[3.45565 27.1554 3.86714];
rgb2lms(3,:)=[0.0299566 0.184309 1.46709];

protaLMSvectors = protaNOPE;
deutaLMSvectors = deuteraNOPE;

%reshaping color reduced 3d matrix for easy transformation
disp(length(inputImage(:,1,1)))
disp(length(inputImage(1,:,1)))
for j=1:dim(1) %column traverse
    for k=1:dim(2) %row traverse
        protapixel = [protaNOPE(j,k,1); protaNOPE(j,k,2); protaNOPE(j,k,3)];
        deutapixel = [deuteraNOPE(j,k,1); deuteraNOPE(j,k,2); deuteraNOPE(j,k,3)];
        protaLMSvectors(j,k,:)=rgb2lms*protapixel;
        deutaLMSvectors(j,k,:)=rgb2lms*deutapixel;
        %for i=1:3 %depth traverse 3 deep
        %    protaRGBvectors(1,i,(j.*k))=protaNOPE(k,j,i);
        %    deutaRGBvectors(1,i,(j.*k))=deuteraNOPE(k,j,i);
        %end
    end
end

%transformation RGB to LMS (rgb2lms)
%for i=1:length(protaRGBvectors)    
%    protaLMSvectors(1,:,i)=protaRGBvectors(1,:,i)*rgb2lms;
%    deutaLMSvectors(1,:,i)=deutaRGBvectors(1,:,i)*rgb2lms;
%end

%#4
%color domain transform for dichromat protanope
lms2lmsPro(1,:)=[0 2.02344 -2.52581];
%lms2lmsPro(1,:)=[0 0 0];
lms2lmsPro(2,:)=[0 1 0];
lms2lmsPro(3,:)=[0 0 1];

%color domain transform for dichromat deuteranope
lms2lmsDeu(1,:)=[1 0 0];
lms2lmsDeu(2,:)=[0.494207 0 1.24827];
lms2lmsDeu(3,:)=[0 0 1];

%LMS transformation for respective dichromat deficiency
for j=1:dim(1)
    for k=1:dim(2)
        protapixel = [protaLMSvectors(j,k,1); protaLMSvectors(j,k,2); protaLMSvectors(j,k,3)];
        deutapixel = [deutaLMSvectors(j,k,1); deutaLMSvectors(j,k,2); deutaLMSvectors(j,k,3)];
        protaLMSvectors(j,k,:)=lms2lmsPro*protapixel;
        deutaLMSvectors(j,k,:)=lms2lmsDeu*deutapixel;
    end
end

%#5 LMS with dichromat deficiencies Transformed back to RGB
lms2rgb(1,:)=[0.080944 -0.130504 0.116721];
lms2rgb(2,:)=[-0.0102485 0.0540194 -0.113615];
lms2rgb(3,:)=[-0.000365294 -0.00412163 0.693513];

protaRGBvectors2 = protaLMSvectors;
deutaRGBvectors2 = deutaLMSvectors;
for j=1:dim(1)
    for k=1:dim(2)
        protapixel = [protaLMSvectors(j,k,1); protaLMSvectors(j,k,2); protaLMSvectors(j,k,3)];
        deutapixel = [deutaLMSvectors(j,k,1); deutaLMSvectors(j,k,2); deutaLMSvectors(j,k,3)];
        protaRGBvectors2(j,k,:)=lms2rgb*protapixel;
        deutaRGBvectors2(j,k,:)=lms2rgb*deutapixel;
    end
end


%#6 

%reshaping back to 3d matrices
%for j=1:length(inputImage(1,:,1)) %column traverse
%    for k=1:length(inputImage(:,1,1)) %row traverse
%        for i=1:3 %depth traverse 3 deep
%            protaNOPE2(k,j,i)=protaRGBvectors2(1,i,(j*k));
%            deuteraNOPE2(k,j,i)=deutaRGBvectors2(1,i,(j*k));
%        end
%    end
%end
protaDAC = protaRGBvectors2;
deuteraDAC = deutaRGBvectors2;
for i=1:3
    protaDAC(:,:,i) = 255*(protaRGBvectors2(:,:,i)).^(1/(2.2));
    deuteraDAC(:,:,i) = 255*(deutaRGBvectors2(:,:,i)).^(1/(2.2));
end

protaNOPE2 = uint8(protaRGBvectors2);
deuteraNOPE2 = uint8(deutaRGBvectors2);
inputImage = uint8(inputImage);

figure;
imshow(protaNOPE2);
figure;

imshow(deuteraNOPE2);

figure;
imshow(inputImage);
