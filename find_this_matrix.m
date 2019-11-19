function index = find_this_matrix(a,b)
	% a is matrix, b is a vector
	% find  matrix a exist vector b
	i = 0;
	k = size(a,1)
	for j = 1:k
		if a(j,:) == b
			i=i+1;
			index(i)=j;
		end
	end
	index = index'
end
