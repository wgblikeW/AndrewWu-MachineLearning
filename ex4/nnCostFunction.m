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

X_modified = [ones(m,1),X];
a_layer1 = zeros(size(X_modified,2),1); % X features and bias (+1) dimension vector
a_layer2 = zeros(hidden_layer_size,1); % hidden layer neuron unit
a_layer3 = zeros(num_labels,1); % output layer
for i=1:m
    a_layer1 = X_modified(i,:)';
    z_2 = Theta1 * a_layer1;
    a_layer2 = sigmoid(z_2);
    a_layer2 = [1;a_layer2]; % adding +1 bias
    z_3 = Theta2 * a_layer2;
    a_layer3 = sigmoid(z_3);
    vector_y = zeros(num_labels,1);
    vector_y(y(i)) = 1;
    
    %--------------------------compute delta-------------------------------
    delta_3 = a_layer3 - vector_y;
    delta_2 = Theta2(:,2:end)'*delta_3.*sigmoidGradient(z_2); % with no theta0
    %--------------------------compute delta-------------------------------
    
    %--------------------------coumpute epsilon----------------------------
    Theta2_grad = Theta2_grad + delta_3*a_layer2';
    Theta1_grad = Theta1_grad + delta_2*a_layer1';
    %--------------------------coumpute epsilon----------------------------

    J = J + sum((-vector_y.*log(a_layer3) - (1-vector_y).*log(1-a_layer3)));
end


J = J/m; % with no regularized
Theta1(:,1)=0; Theta2(:,1)=0; % no theta0
R = lambda/(2*m)* (sum(Theta1.^2,'all') + sum(Theta2.^2,'all') );
J = J + R; % with regularized

Theta1_grad = Theta1_grad./m; % with no regularized
Theta2_grad = Theta2_grad./m; % with no regularized

Theta1_grad = Theta1_grad + 1/m*lambda*Theta1; %with regularized
Theta2_grad = Theta2_grad + 1/m*lambda*Theta2; %with regularized

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
