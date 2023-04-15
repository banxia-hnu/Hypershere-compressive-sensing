function [x, D] = IterationGR_1D(y, x, Phi, pinvPhi, block_size, num_rows, num_cols, ...
    lambda, num_levels)

x = col2im(x, [block_size block_size], ...
    [num_rows num_cols], 'distinct');                      
                                             
x = wiener2(x, [3, 3]);                                                                         
x = im2col(x, [block_size block_size], 'distinct');        
x = x + pinvPhi * (y - Phi * x);                   
x1 = col2im(x, [block_size block_size], ...
    [num_rows num_cols], 'distinct');                        
x_check = x1;                                             
x_check = waveletcdf97(x_check, num_levels);                                             

threshold = lambda  * sqrt(2 * log(num_rows * num_cols)) * (median(abs(x_check(:))) / 0.6745);         

x_check(abs(x_check) < threshold) = 0;                    
x = waveletcdf97(x_check , -num_levels);                                                                                                               
x = im2col(x, [block_size block_size], 'distinct');          
x = x + pinvPhi * (y - Phi * x);                                                
x2 = col2im(x, [block_size block_size], ...
    [num_rows num_cols], 'distinct');        
D = RMS(x1, x2);                   

end
  




