
def TSP(distance,state,size)
	sum = 0
	
	for i in 0...size-1
		sum = sum + distance[state[i]-1][state[i+1]-1].to_i
	end

	sum = sum + distance[state[size-1]-1][state[0]-1].to_i

	return sum
end