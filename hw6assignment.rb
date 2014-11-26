# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
	All_My_Pieces = [
		[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
        rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
        [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
        [[0, 0], [0, -1], [0, 1], [0, 2]]],
        rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
        rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
        rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
        rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]),  # Z
		rotations([[0, 0], [0,1], [1,1], [1, 0], [2, 0]]),
		rotations([[0, 0], [0, 1], [1, 1]]),
		[[[-2, 0], [-1, 0], [0, 0], [1, 0], [2, 0]], [[0, 2], [0, 1], [0, 0], [0, -1], [0, -2]]]
	]

	Cheat_Piece = [[0, 0]]
    # your enhancements here
	def self.next_piece (board, cheat=false)
		if cheat
			MyPiece.new(Cheat_Piece, board)
		else
	    	MyPiece.new(All_My_Pieces.sample, board)
		end
	end
end

class MyBoard < Board
	# your enhancements here
	def initialize (game)
    	@grid = Array.new(num_rows) { Array.new(num_columns) }
	    @current_block = MyPiece.next_piece(self)
    	@score = 0
    	@game = game
    	@delay = 500
		@c_pressed = false
	end

	def next_piece
		@current_block = MyPiece.next_piece(self, @c_pressed)
		@c_pressed = false if @c_pressed
   		@current_pos = nil
	end

	def rotate_180
		if !game_over? and @game.is_running?
    		@current_block.move(0, 0, -2)
    	end
    	draw
	end
	
	def c_press
		if score >= 100 and not @c_pressed
			@c_pressed = true
			@score = @score - 100
		end
	end

end

class MyTetris < Tetris
  # your enhancements here
	def set_board
    	@canvas = TetrisCanvas.new
    	@board = MyBoard.new(self)
    	@canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    	@board.draw
	end

	def key_bindings
		super
		@root.bind('u', proc {@board.rotate_180})
		@root.bind('c', proc {@board.c_press})
	end
end

