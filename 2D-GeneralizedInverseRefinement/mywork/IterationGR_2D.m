function [X, D] = IterationGR_2D(Y, X, Phi1, Phi2, ...
    pinvPhi1, pinvPhi2, num_rows, num_cols, lambda, num_levels, C)

[af, sf] = farras;
L = 12;
r = 0.8; 
X1 = X; 

X = wiener2(X, [3, 3]);                                 
X = X +  pinvPhi1 * (Y-Phi1 *X * Phi2')* pinvPhi2;   


X = X - r * derivating_of_TV(X, num_rows);     

X_check = dwt2D(symextend(X, L * 2^(num_levels - 1)), ...
    num_levels, af);                                                 
if (nargin == 9)                            
  end_level = 1; 
else  
  end_level = num_levels - 1;  
end

X_check = ThresholdCorrection(X_check, end_level, lambda, C, num_rows, num_cols);
X = idwt2D(X_check, num_levels, sf);           
Irow = (L * 2^(num_levels - 1) + 1):(L * 2^(num_levels - 1) + num_rows);
Icol = (L * 2^(num_levels - 1) + 1):(L * 2^(num_levels - 1) + num_cols);
X = X(Irow, Icol);


X = X +  pinvPhi1 * (Y-Phi1 *X * Phi2')* pinvPhi2;                
D = RMS(X, X1);


function x_check = ThresholdCorrection(x_check, end_level, lambda, C, num_rows, num_cols)

windowsize  = 3;
windowfilt = ones(1, windowsize)/windowsize;
tmp = x_check{1}{3};

Nsig = median(abs(tmp(:)))/0.6745 * C * sqrt(2 * log(num_rows * num_cols));

for scale = 1:end_level
  for dir = 1:3
    Y_coefficient = x_check{scale}{dir};
    Y_parent = x_check{scale+1}{dir};
    Y_parent = expand(Y_parent);
   
    Wsig = conv2(windowfilt, windowfilt, (Y_coefficient).^2, 'same');
    Ssig = sqrt(max(Wsig-Nsig.^2, eps));
 
    T = sqrt(3)*Nsig^2./Ssig;
    
    x_check{scale}{dir} = bishrink(Y_coefficient, ...
	Y_parent, T*lambda);
  end
end