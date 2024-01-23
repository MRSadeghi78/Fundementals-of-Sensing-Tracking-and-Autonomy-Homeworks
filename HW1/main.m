S = readmatrix('groundtruth.csv');
R = readmatrix('measurements.csv');
k = size(S,1);
alpha = [];
M = [];
% Putting all ground truth measurments in one matrix named alpha
% the size of alpha will be 3k*1, k being the number of measurements
for i = 1:k
    alpha = [alpha S(i,:)];
end
alpha = alpha';
% Building the M and beta matrices based on this equation:
% alpha = M*beta
% the size of M will be 3k*12
for i = 1:k
    M = [M; R(i,:) 1 0 0 0 0 0 0 0 0];
    M = [M; 0 0 0 0 R(i,:) 1 0 0 0 0];
    M = [M; 0 0 0 0 0 0 0 0 R(i,:) 1];
end

MT = transpose(M);
beta = pinv(M)*alpha;

% Computing the A and b matrices from the beta matrix
% y = A*r + b
A = [beta(1), beta(2), beta(3); beta(5), beta(6), beta(7); beta(9), beta(10), beta(11)];
b = [beta(4), beta(8), beta(12)];
RT = transpose(R);
y = R*A' + b;

% Computing error between the calibration results and the ground truth
e = S - y;
% Computing sum of squares
sum_squares_error = 0;
for i = 1:k
    sum_squares_error = sum_squares_error + e(i,1)^2 + e(i,2)^2 + e(i,3)^2;
end
