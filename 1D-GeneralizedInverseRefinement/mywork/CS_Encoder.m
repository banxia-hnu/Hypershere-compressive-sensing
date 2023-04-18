function y = CS_Encoder (current_image, Phi)

[M N] = size(Phi);          
 
block_size = sqrt(N);       

[num_rows num_cols] = size(current_image);                              

x = im2col(current_image, [block_size block_size], 'distinct');    

y = Phi * x;    
