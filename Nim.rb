class Nim

	attr_accessor :current_board, :binary_string_length

	def initialize

		@@board_configurations = [[1, 3, 5, 7], [4, 3, 7]]
	
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

		@computer_player = 0

		while (@computer_player < 1 || @computer_player > 2)
			print "Select computer (1 or 2): "
			@computer_player = STDIN.gets.chomp.to_i
		end

		player_turn

	end

	def player_turn

		display_board
		row = 0

		while ( (row < 1) || (row > @current_board.size) || @current_board[row - 1] == 0)
			print "Select the row (1-#{@current_board.size}): "
			row = STDIN.gets.chomp.to_i
			if (@current_board[row - 1] == 0)
				puts "There are no more sticks in that row!"
			end
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
			if ( @computer_player == 1 )
				computer_turn
			else
				dumb_computer_turn
			end
		end

	end

	def computer_turn
		
		game_state = convert_to_binary(@current_board)

		problem_columns = find_problem_columns(game_state)

		selected_row, selected_row_index = select_row(game_state, problem_columns)

		target_number = 0

		# Check if somehow the board is already in the kernel state (different board configurations)
		if (selected_row.nil?)

			# Randomly choose a target row and number of sticks
			selected_row_index,	target_number = make_random_choice(@current_board)
		else
			target_number = choose_number_sticks(selected_row, problem_columns)
		end

		finish_computer_turn(selected_row_index, target_number)
	end

	def dumb_computer_turn
		selected_row_index, target_number = make_random_choice(@current_board)
		finish_computer_turn(selected_row_index, target_number)
	end

	##############################################################################
	######################### Computer Helper functions ##########################
	##############################################################################

	# Converts the number of 'sticks' in each row to binary
	def convert_to_binary(board)

		game_state = []

		# game_state becomes a 2D array
		board.each do |num|
			binary_string = num.to_s(2)
			# Make sure all the binary strings are the same length
			(@binary_string_length - binary_string.length).times do 
				binary_string = "0#{binary_string}"
			end
			string_array = binary_string.split("")
			int_array = []
			string_array.each do |element|
				int_array << element.to_i 
			end
			game_state << int_array
		end

		return game_state
	end

	# Find the columns that add to 1 (the 'problem' columns)
	def find_problem_columns(game_state)
		problem_columns = []

		for i in 0...@binary_string_length
			sum = 0
			game_state.each do |row|
				sum += row[i]
			end
			if (sum % 2 == 1)
				problem_columns << i
			end
		end
		return problem_columns
	end

	# Select a row to take sticks from
	def select_row(game_state, problem_columns)
		selected_row = nil
		selected_row_index = 0
		game_state.each_index do |i|
			if (game_state[i][problem_columns[0]] == 1)
				selected_row = game_state[i]
				selected_row_index = i
				break
			end
		end
		return selected_row, selected_row_index
	end

	# Used for the dumb computer and (in isolated cases) for the smart computer
	def make_random_choice(board)
		# Pick a random but valid row
		selected_row_index = rand(board.size)
		while (board[selected_row_index] == 0)
			selected_row_index = rand(board.size)
		end
		# Pick a random number of sticks
		target_number = rand(board[selected_row_index])
		return selected_row_index, target_number
	end

	# Find new value for selected row
	def choose_number_sticks(selected_row, problem_columns)
		selected_row.each_index do |index|
			# Toggle any digit from a problem column
			if (problem_columns.include?(index))
				if (selected_row[index] == 0)
					selected_row[index] = 1
				else
					selected_row[index] = 0
				end
			end
		end
		target_number = selected_row.join.to_i(2)
		return target_number
	end

	def finish_computer_turn(selected_row_index, target_number)
		puts "Computer took #{@current_board[selected_row_index] - target_number} stick(s) from row #{selected_row_index + 1}"

		@current_board[selected_row_index] = target_number

		if (player_won?)
			puts "Computer wins the game!"
			puts "Thank you for playing"
		else
			player_turn
		end
	end

	##############################################################################
	##############################################################################

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

end
