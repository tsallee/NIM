class Nim

	def initialize

		@@board_configurations = [[1, 3, 5, 7], [4, 3, 7]]
	
	end

	def player_turn

		display_board
		row = 0

		while ( (row < 1) || (row > @current_board.size) ) do
			print "Select the row (1-#{@current_board.size}): "
			row = STDIN.gets.chomp.to_i
		end

		num_sticks = 0
		while ( (num_sticks < 1) || (num_sticks > @current_board[row - 1]) ) do
			print "Select the number of sticks (1-#{@current_board[row - 1]}): "
			num_sticks = STDIN.gets.chomp.to_i
		end

		@current_board[row - 1] -= num_sticks

		if player_won?
			puts "Congratulations! You Won!"
			puts "Thank you for playing"
		else
			computer_turn
		end

	end

	def computer_turn

		game_state = []
		
		# Converts the number of 'sticks' in each row to binary
		# game_state becomes a 2D array
		@current_board.each do |num|
			binary_string = num.to_s(2)
			# Make sure all the binary strings are the same length
			(@binary_string_length - binary_string.length).times do 
				binary_string = "0#{binary_string}"
			end
			game_state << binary_string.split("")
		end

		# Find the columns that add to 1
		problem_columns = []

		for i in 0...@binary_string_length
			sum = 0
			game_state.each do |row|
				sum += row[i].to_i 
			end
			if (sum % 2 == 1)
				problem_columns << i
			end
		end

		# Select a row to take sticks from
		selected_row = nil
		selected_row_index = 0
		game_state.each_index do |i|
			if (game_state[i][problem_columns[0]].to_i == 1)
				selected_row = game_state[i]
				selected_row_index = i
				break
			end
		end

		target_number = 0
		# Check if somehow the board is already in the kernel state (different board configurations)
		if (selected_row.nil?)
			# Pick a random but valid row
			selected_row_index = rand(@current_board.size)
			while (@current_board[selected_row_index] == 0)
				selected_row_index = rand(@current_board.size)
			end
			# Pick a random number of sticks
			target_number = rand(@current_board[selected_row_index])
		else
			# Find new value for selected row
			selected_row.each_index do |index|
				# Toggle any digit from a problem column
				if (problem_columns.include?(index))
					if (selected_row[index] == "0")
						selected_row[index] = "1"
					else
						selected_row[index] = "0"
					end
				end
			end

			target_number = selected_row.join.to_i(2)
		end

		puts "Computer took #{@current_board[selected_row_index] - target_number} stick(s) from row #{selected_row_index + 1}"

		@current_board[selected_row_index] = target_number

		if (player_won?)
			puts "Computer wins the game!"
			puts "Thank you for playing"
		else
			player_turn
		end
	end

	def player_won?

		@current_board.each do |num|
			if num != 0
				return false
			end
		end
		return true
	end

	def display_board
		puts ""
		@current_board.each_index do |i|
			x_string = ""
			@current_board[i].times do
				x_string << "X"
			end
			puts "Row #{i + 1}: #{x_string}"
		end
		puts ""
	end

	def new_game

		puts "Welcome to Nim!"

		@@board_configurations.each_index do |i|
			puts "Configuration #{i + 1}: [#{@@board_configurations[i].join(", ")}]"
		end

		board_config = 0
		puts ""

		while (board_config != 1 && board_config != 2)
			print "Select board configuration (1 - #{@@board_configurations.size}): "
			board_config = STDIN.gets.chomp.to_i
		end

		@current_board = @@board_configurations[board_config-1]

		# Set the length of the binary string to the longest possible row value
		@binary_string_length = @current_board.max.to_s(2).length

		puts "1: Smart Computer Player"
		puts "2: Dumb Computer Player"

		computerPlayer = 0

		while (computerPlayer != 1 && computerPlayer != 2)
			print "Select computer (1 or 2): "
			computerPlayer = STDIN.gets.chomp.to_i
		end

		player_turn

	end

end

nim_game = Nim.new
nim_game.new_game
