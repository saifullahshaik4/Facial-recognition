%% Input database files into Matlab
clear;
Database_Size = 30;

for j = 1:Database_Size
    image_read = imread(['database\person' num2str(j) '.pgm']);
    [m, n] = size(image_read);
    P(:, j) = reshape(image_read, m * n, 1);
end;

%% Computing and displaying the mean face
mean_face = mean(P, 2);
imshow(uint8(reshape(mean_face, m, n)))

%% Subtract the mean face
P = double(P);
P = P - mean_face * ones(1, Database_Size);

%% Compute the covariance matrix of the set and its eigenvalues and eigenvectors
[Vectors, Values] = eig(P' * P);
EigenVectors = P * Vectors;

for i = 1:size(EigenVectors, 2)
    EigenVectors(:, i) = EigenVectors(:, i) / norm(EigenVectors(:, i));
end

%% Display the set of eigenfaces
for j = 2:Database_Size
    if j == 2
        EigenFaces = reshape(EigenVectors(:, j) + mean_face, m, n);
    else
        EigenFaces = [EigenFaces reshape(EigenVectors(:, j) + mean_face, m, n)];
    end;
end

EigenFaces = uint8(EigenFaces);
figure;
imshow(EigenFaces);

%% Orthogonality and symmetry
Products = EigenVectors' * EigenVectors;
disp(Products);

%% Recognition of an altered image (sunglasses)
image_read = imread(['database\person30altered1.pgm']);
U = reshape(image_read, m * n, 1);

NormsEigenVectors = diag(Products);
W = (EigenVectors' * (double(U) - mean_face));
W = W ./ NormsEigenVectors;

U_approx = EigenVectors * W + mean_face;
image_approx = uint8(reshape(U_approx, m, n));
figure;
imshow([image_read, image_approx])

%% Recognition of an altered image (lower part of the face)
image_read = imread(['database\person30altered2.pgm']);
U = reshape(image_read, m * n, 1);

W = (EigenVectors' * (double(U) - mean_face));
W = W ./ NormsEigenVectors;

U_approx = EigenVectors * W + mean_face;
image_approx = uint8(reshape(U_approx, m, n));
figure;
imshow([image_read, image_approx])

%% Recognition of a person not in the database
image_read = imread(['database\person31.pgm']);
U = reshape(image_read, m * n, 1);

W = (EigenVectors' * (double(U) - mean_face));
W = W ./ NormsEigenVectors;

U_approx = EigenVectors * W + mean_face;
image_approx = uint8(reshape(U_approx, m, n));
figure;
imshow([image_read, image_approx])

