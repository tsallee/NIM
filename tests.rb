require 'test/unit'
require 'Nim'

class TestNim < Test::Unit::TestCase

	@@nim_game = Nim.new

	def test_convert_to_binary
		
		board = [0, 3, 5, 7]
		@@nim_game.binary_string_length = 3

		expected_array = [
		  	[0, 0, 0],
		  	[0, 1, 1],
		  	[1, 0, 1],
		  	[1, 1, 1]
		]

		actual_array = @@nim_game.convert_to_binary(board)

		assert_equal(expected_array, actual_array)

		board = [3, 4, 0, 9]
		@@nim_game.binary_string_length = 4

		expected_array = [
		  	[0, 0, 1, 1],
		  	[0, 1, 0, 0],
		  	[0, 0, 0, 0],
		  	[1, 0, 0, 1]
		]

		actual_array = @@nim_game.convert_to_binary(board)

		assert_equal(expected_array, actual_array)

	end

	def test_find_problem_columns

		game_state = [
		  	[0, 0, 0],
		  	[0, 1, 1],
		  	[1, 0, 1],
		  	[1, 1, 1]
		]
		@@nim_game.binary_string_length = 3

		expected_array = [2]

		actual_array = @@nim_game.find_problem_columns(game_state)

		assert_equal(expected_array, actual_array)

		game_state = [
		  	[0, 0, 1, 1],
		  	[0, 1, 0, 0],
		  	[0, 0, 0, 0],
		  	[1, 0, 0, 1]
		]
		@@nim_game.binary_string_length = 4

		expected_array = [0, 1, 2]

		actual_array = @@nim_game.find_problem_columns(game_state)

		assert_equal(expected_array, actual_array)

	end

	def test_select_row

		game_state = [
		  	[0, 0, 0],
		  	[0, 1, 1],
		  	[1, 0, 1],
		  	[1, 1, 1]
		]

		problem_columns = [2]

		expected_row_index = 1

		actual_row, actual_row_index = @@nim_game.select_row(game_state, problem_columns)

		assert_equal(expected_row_index, actual_row_index)

		game_state = [
		  	[0, 0, 1, 1],
		  	[0, 1, 0, 0],
		  	[0, 0, 0, 0],
		  	[1, 0, 0, 1]
		]

		problem_columns = [0, 1, 2]

		expected_row_index = 3

		actual_row, actual_row_index = @@nim_game.select_row(game_state, problem_columns)

		assert_equal(expected_row_index, actual_row_index)

	end

	# Validates that the computer correctly chooses the number
	# of sticks to leave in the target row
	def test_choose_number_sticks

		selected_row = [1, 0, 1]
		problem_columns = [2]

		expected_number_left = 4

		actual_number_left = @@nim_game.choose_number_sticks(selected_row, problem_columns)

		assert_equal(expected_number_left, actual_number_left)

		selected_row = [1, 0, 0, 1]
		problem_columns = [0, 1, 2]

		expected_number_left = 7

		actual_number_left = @@nim_game.choose_number_sticks(selected_row, problem_columns)

		assert_equal(expected_number_left, actual_number_left)

	end

end