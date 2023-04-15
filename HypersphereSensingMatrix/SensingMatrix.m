function sm = SensingMatrix(M, N, seed1, seed2)
index = RandomIndex(N, seed1);
sm = zeros(M, N);
for i = 1:N
    s = ThreeSphere(index(i), N, 0.618);
    h = RandomCoefficient(M - 3, seed2 + i);
    a = zeros(1, M);
    a(1:3) = s;
    for j = 1:(M-3)
        a = a * h(j);
        a(j+3) = h(j) / abs(h(j)) * sqrt(1 - h(j)^2);
    end
    sm(:, i) = a;
end
    


function index = RandomIndex (N, seed)
rng('default'); 
rng(seed);
index = randperm(N);

    
function rm = RandomCoefficient(N, seed)
rng('default');  
rng(seed); 
rm = zeros(1, N);
for i = 1:N
%     rm(i) = (0.1 * rand(1, 1) + 0.9) * randsample([-1, 1], 1);
    rm(i) = (0.0001 * rand(1, 1) + 0.9999) * randsample([-1, 1], 1);
end


function s = ThreeSphere(i, N, f)
s = zeros(1, 3);
s(3) = (2 * i - 1) / N - 1;
s(1) = sqrt(1 - s(3)^2) * cos(2 * pi * i * f);
s(2) = sqrt(1 - s(3)^2) * sin(2 * pi * i * f);
