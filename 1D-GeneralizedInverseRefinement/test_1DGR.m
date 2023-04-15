clc;
clear;

addpath('..\images');
addpath('..\HypersphereSensingMatrix');
addpath('..\WaveletSoftware');
addpath('mywork'); 


% test images
filename = 'lenna';                                 
% filename = 'peppers';                         
% filename = 'barbara';                     
% filename = 'goldhill';                        
% filename = 'mandrill';   
original_filename = [ filename '.pgm'];   
original_image = double(imread(original_filename));      
[num_rows, num_cols] = size(original_image); 

%  Parameters
subrate = 0.5; 
C = 0.8; %0.95
size_images = num_rows;  
block_size = 32;
num_levels = 3;
max_iterations = 200;
length_of_blocks = block_size * block_size;  


%%  1DCS encoding 
N = block_size * block_size;        
M = round(subrate * N); 
Phi = SensingMatrix(M, N, 1233, 1234);

y = CS_Encoder(original_image, Phi);


%%  1DCS decoding 
reconstructed_image = GeneralizedInverseRefinement_1D(y, Phi, ...
    num_rows, num_cols, num_levels, C);
PSNR = psnr(uint8(reconstructed_image), uint8(original_image));                    
figure(1);
imshow(uint8(original_image),'Border','tight');
figure(2);
imshow(uint8(reconstructed_image),'Border','tight');
