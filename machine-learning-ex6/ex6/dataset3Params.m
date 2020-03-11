function [C, sigma] = dataset3Params(X, y, Xval, yval)
%DATASET3PARAMS returns your choice of C and sigma for Part 3 of the exercise
%where you select the optimal (C, sigma) learning parameters to use for SVM
%with RBF kernel
%   [C, sigma] = DATASET3PARAMS(X, y, Xval, yval) returns your choice of C and 
%   sigma. You should complete this function to return the optimal C and 
%   sigma based on a cross-validation set.
%

% You need to return the following variables correctly.
C = 1;
sigma = 0.3;

% ====================== YOUR CODE HERE ======================
% Instructions: Fill in this function to return the optimal C and sigma
%               learning parameters found using the cross validation set.
%               You can use svmPredict to predict the labels on the cross
%               validation set. For example, 
%                   predictions = svmPredict(model, Xval);
%               will return the predictions on the cross validation set.
%
%  Note: You can compute the prediction error using 
%        mean(double(predictions ~= yval))
%
C_list = [0.01,0.03,0.1,0.3,1,3,10,30];
sigma_list = [0.01,0.03,0.1,0.3,1,3,10,30];

Optimum_C = C_list(1);
Optimum_sigma = sigma_list(1);
min_error = 5000;
for i=1:length(C_list),
  Current_C = C_list(i);
  for j=1:length(sigma_list),
    Current_sigma = sigma_list(j);
    %Looping through each sigma for each C parameter by inner for loop 
    % and then training SVM on the training set 
    %to use Gaussian kernel and optimize cost function to determine parameters
    %for each model 
    model= svmTrain(X, y, Current_C, @(x1, x2) gaussianKernel(x1, x2, Current_sigma));
    %using parameters determined from trained model
    % to determine the predicted output from cross validation set
    predictions = svmPredict(model, Xval);
    %finding error in the predicted value as compared to actual output yval for cross validation set
    err = mean(double(predictions ~= yval));
    %if the error is less than previous error declared as min_error,
    %then set the error as min_error 
    %and loop through again for next combination of C value and sigma value.
    if err < min_error
      Optimum_C = Current_C;
      Optimum_sigma = Current_sigma;
      min_error = err;
    endif
    
  endfor
endfor


% Finally evaluating the C parameter
%and sigma parameter equal to the Optimum_C
%and Optimum_sigma found from Cross Validation set.

C= Optimum_C;
sigma = Optimum_sigma;

% =========================================================================

end
