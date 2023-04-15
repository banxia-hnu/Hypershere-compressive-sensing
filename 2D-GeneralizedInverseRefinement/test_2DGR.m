clc;
clear;

addpath('..\images');
addpath('..\HypersphereSensingMatrix');
addpath('..\WaveletSoftware');
addpath('mywork'); 


%  test images
filename = 'lenna'; 
filename = 'peppers';                         
filename = 'barbara';                     
% filename = 'goldhill';                        
% filename = 'mandrill'; 
original_filename = [ filename '.pgm']; 
original_image = double(imread(original_filename));         
[num_rows, num_cols] = size(original_image);    

%  Parameters
subrate = 0.1;
C = 0.8;%0.8 %0.22 %0.15
quantizer_bitdepth = 10;
size_images = num_rows; 
num_levels = 3;  

%% template_matrix
template_matrix = zeros (size_images, size_images);
for i=1:1:size_images  
    for j =1:1:size_images     
    template_matrix (i, j)  = 128;
    end  
end
final_image = original_image - template_matrix;    
    
%%   2DCS encoding 
M = round(sqrt(subrate * size_images* size_images)); 
N = size_images;
Phi1 = SensingMatrix(M, N, 123, 1234);
Phi2 = Phi1;
Y =  Phi1 * final_image * Phi2';

%  Scalar quantization
% [yq, rate_sq] = SQ_Coding (Y, quantizer_bitdepth, num_rows, num_cols);  
yq = Y;

%%  2DCS decoding 
Y_template_matrix =  Phi1 *  template_matrix * Phi2';
Yq = yq + Y_template_matrix;
reconstructed_image = GeneralizedInverseRefinement_2D(Yq, Phi1, Phi2, ...
    num_rows, num_cols, num_levels, C);
PSNR = psnr(uint8(reconstructed_image), uint8(original_image));  

figure(1);
imshow(uint8(original_image),'Border','tight');
figure(2);
imshow(uint8(reconstructed_image),'Border','tight');

