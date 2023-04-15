function reconstructed_image = ...
    GeneralizedInverseRefinement_1D(y, Phi, num_rows, num_cols, num_levels, C)

lambda = C;                        
max_iterations = 200;                           
[~, N] = size(Phi);
block_size = sqrt(N);              
TOL = 0.0001;                                          
D_prev = 0;
pinvPhi = pinv(Phi);
x =  pinvPhi * y;                          
for i = 1:max_iterations       
  [x, D] = IterationGR_1D(y, x, Phi, pinvPhi, block_size, num_rows, num_cols, ...
    lambda, num_levels);
  if ((D_prev ~= 0) && (abs(D - D_prev) < TOL))  
     break;
  end    
  D_prev = D;
end

[x, ~] = IterationGR_1D(y, x, Phi, pinvPhi, block_size, num_rows, num_cols, ...
    lambda, num_levels);
x = col2im(x, [block_size block_size], ...
    [num_rows num_cols], 'distict');                                
reconstructed_image = x;
end





