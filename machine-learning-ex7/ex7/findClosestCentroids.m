function idx = findClosestCentroids(X, centroids)
%FINDCLOSESTCENTROIDS computes the centroid memberships for every example
%   idx = FINDCLOSESTCENTROIDS (X, centroids) returns the closest centroids
%   in idx for a dataset X where each row is a single example. idx = m x 1 
%   vector of centroid assignments (i.e. each entry in range [1..K])
%

% Set K
K = size(centroids, 1);

% You need to return the following variables correctly.
idx = zeros(size(X,1), 1);

% ====================== YOUR CODE HERE ======================
% Instructions: Go over every example, find its closest centroid, and store
%               the index inside idx at the appropriate location.
%               Concretely, idx(i) should contain the index of the centroid
%               closest to example i. Hence, it should be a value in the 
%               range 1..K
%
% Note: You can use a for-loop over the examples to compute this.
%

%run loop through all the training examples

for i=1:size(X,1),
  %create a vector that will contain all the values of distance of all the K 
  %centroids from each ith training example  
  distance_from_centroid = zeros(size(centroids,1),1);
  for k=1:K,
  %computing the distance for ith training from all K centroids by substrancting 
  % features from ith row of X matrix from each of the k row in centroid matrix that
  %taking the squared sum 
  distance_from_centroid(k) = sumsq(X(i,:)- centroids(k,:));
  end;
  %taking min distance for ith example from the k centroid and assigning it
  %to ith index
  [min_distance, min_indx] = min(distance_from_centroid);
  idx(i) = min_indx;
  %now again looping through to itterate over next ith example and
  %find its minimum distance from kth cluster centroid.


endfor





% =============================================================

end

