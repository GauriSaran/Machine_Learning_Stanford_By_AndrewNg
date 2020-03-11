function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

X = [ones(m,1) X];

for i = 1:m,
  a1 = X(i, :)';
  z2 = Theta1 * a1;
  a2 = [1; sigmoid(z2)];
  z3 = Theta2 * a2;
  a3 = sigmoid(z3);
  h = a3; % this is a vector of ith training example of the output from 
  %hypothesis function for all the units/classes in output layer.
  
  %Setting y vector for the ith training example with boolean values 
  %that macthes the actual digit in the output data
  
  y_bool = [1:num_labels]' == y(i);
  %computing cost function of ith term and then adding to the previous term calculated in last itteration
  
  J = J + sum(y_bool.*log(h) + (1-y_bool).*log(1-h));
  %To compute the gradient of parmater matrices- Theta1_grad and Theta2_grad 
  %Taking partial derivatives of each weights in the matrices and
  %for each ith training example and adding them.
  delta3 = a3 - y_bool;
  delta2 = Theta2'*delta3.*(a2.*(1-a2));
  Theta2_grad = Theta2_grad + delta3*a2';
  Theta1_grad = Theta1_grad + delta2(2:end)*a1';
  
  
  
endfor


J = -(J)/m
Theta1_grad = Theta1_grad / m;
Theta2_grad = Theta2_grad / m;


%since Theta1 is regularized only from second column. Therefore when summing over 
%all elements across columns, the size of columns is considered 25 instead of 26 for Theta1 for Regularization purpose

J = J + (lambda/(2*m))*(sumsq(Theta1(:,2:end)(:)) + sumsq(Theta2(:,2:end)(:)));

%Setting all the rows from first column of Theta1 and Theta2 matrices to 0.
%this regularizes parameter of only the actual features and not the bias unit.
T1 = [zeros(size(Theta1, 1),1) Theta1(:, 2:end)]
T2 = [zeros(size(Theta2, 1),1) Theta2(:, 2:end)]
Theta1_grad = Theta1_grad + (lambda / m) * T1
Theta2_grad = Theta2_grad + (lambda / m) * T2;













% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
