require 'csv'
require 'nyaplot'
require_relative 'TSP.rb'

def Simulated_Annealing(temperature,temperature_min,alpha,distance,size)
	state, new_state,random,energy,result = [],[],[],[],[]
	start = Time.now

	#Generate random state S
	begin 
		number = rand(size)+1
		state.push(number) unless state.include?(number)
	end while state.size < size

	puts "Max Temperature: #{temperature}"
	puts "Min Temperature: #{temperature_min}"
	puts "Initial State: #{state}"

	#Calculate cost of S
	energy.push(TSP(distance,state,size))

	sc_y,line_x,sc_x,line_y = [],[],[],[] 
	x=1

	while temperature > temperature_min
		#puts "-----------------------------Simulated Annealing-----------------------------------------"
		#puts "State: "
		#puts state.inspect
		
		#Generate 2 random numbers
		loop do
			# Ramdom Positions
			random = Array.new(2) { rand(0..size-1) }

			break if random.uniq.length == random.length 
		end

		#Copy state to new_state
		new_state = state.clone

		#Swapping 2 numbers in new_state S'.
		new_state[random[0]], new_state[random[1]] = new_state[random[1]],new_state[random[0]]

		#Calculate cost of S'
		energy[1] = TSP(distance,new_state,size)

		#Compare cost S and S'
		if energy[1] < energy[0]
			state = new_state
			energy[0] = energy[1]
		elsif exp = Math.exp( -(energy[1]-energy[0]) / temperature) > rand(0.0..1.0)
			state = new_state
			energy[0] = energy[1]
		end

		#Cooling Schedule. Decrement.
		temperature = alpha * temperature
		#puts "Current Temperature: #{temperature}"

		################################ GRAPH #################################################
		line_x.push(x)
	 	line_y.push(temperature)
	 	sc_y.push(energy[0])
	 	sc_x.push(x)
	 	x=x+1
	 	################################ GRAPH #################################################
	end

	################################ GRAPH #################################################
		plot = Nyaplot::Plot.new
		plot2 = Nyaplot::Plot.new
		sc = plot.add(:scatter, sc_x, sc_y)
		line = plot2.add(:line, line_x, line_y)
		sc.color('#aff000')
		sc.title('Cost')
		plot.x_label('Iteration')
		plot.y_label('Cost')
		plot.legend(true)

		line.color('#aff000')
		line.title('Temperature')
		plot2.x_label('Iteration')
		plot2.y_label('Temperature')
		plot2.legend(true)

		plot.export_html("SA-TSP_Cost.html")
		plot2.export_html("SA-TSP_Temp.html")
	################################ GRAPH #################################################
	result[0] = state
	result[1] = energy[0]
	result[2] = Time.now - start
	return result
end

if __FILE__ == $0
# Configuration
distance, result = [],[]
temperature,temperature_min, alpha = 10000,0.001, 0.99
size = 0

#Open CSV file.
CSV.foreach('matrix4x4.csv') do |row|
  distance.push(row)
end

puts "Distance Matrix: "
puts distance.inspect
size = distance.count


puts "Size of Matrix: #{size}x#{size}"

result = Simulated_Annealing(temperature, temperature_min,alpha,distance,size)

puts "Final State: #{result[0]}"
puts "Cost: #{result[1]}"
puts "Time: #{result[2]} seconds."

end