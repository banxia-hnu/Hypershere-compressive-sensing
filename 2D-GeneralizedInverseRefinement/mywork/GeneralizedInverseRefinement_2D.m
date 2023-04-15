function reconstructed_image = ...
    GeneralizedInverseRefinement_2D (Y, Phi1, Phi2, num_rows, num_cols, num_levels, C)

addpath('mywork'); 
lambda = 6;
max_iterations = 200;
TOL = 0.0001;
D_prev = 0;                                              
pinvPhi1 =  pinv (Phi1);
pinvPhi2 = pinv (Phi2');

X = pinvPhi1 * Y * pinvPhi2;
for i = 1:max_iterations  
    [X, D] = IterationGR_2D (Y, X, ...
     Phi1, Phi2, pinvPhi1, pinvPhi2, num_rows, num_cols, lambda, num_levels, C);                   
    if ((D_prev ~= 0) && (abs(D - D_prev) < TOL))     
      break;   
    end
    D_prev = D;
end

[X D] = IterationGR_2D (Y, X, ...
    Phi1, Phi2,  pinvPhi1, pinvPhi2, num_rows, num_cols, lambda, num_levels, C);
reconstructed_image = X;             

