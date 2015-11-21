# module Connect_four

	class Coord
		attr_accessor :x, :y
		def initialize(x,y)
			@x = x
			@y = y
		end
	end

	class Player
		attr_accessor :name, :piece

		def initialize(name, piece)
			if piece.length != 1
				raise ArgumentError
			else
				@name = name
				@piece = piece
			end
		end
	end

	class Board

		ROWS = 6
		COLUMNS = 7
		TO_CONNECT = 4

		attr_accessor :state, :players, :current_player

		def initialize(players,state)
			@players = players
			@current_player = @players.first
			@state = state
		end

		def Board.empty_state
			row = Array.new(COLUMNS)
			table = []
			ROWS.times do
				table << Array.new(row)
			end
			table
		end

		def to_s
			str = ""
			@state.each { |row|
				row.each {|tile|
					if tile.nil?
						str = str + "* "
					else
						str = str + "#{tile} "
					end
				}
				str = str + "\n"
			}
			str
		end

		def print_state
			column_markers = ""
			1.upto(COLUMNS) do |i|
				column_markers += "#{i} "
			end
			puts column_markers
			puts self.to_s
		end

		def set(coord)
			@state[coord.y-1][coord.x-1] = @current_player.piece
		end

		def get(coord)
			@state[coord.y-1][coord.x-1]
		end

		def make_move(col)
			r_i = ROWS-1
			until @state[r_i][col-1].nil?
				r_i = r_i - 1
				raise ArgumentError, "column full" if r_i < 0
			end
			@state[r_i][col-1] = @current_player.piece
		end

		def swap_players
			other_player = players.select {|x| x!= @current_player}.first
			@current_player = other_player
		end

		def victory?
			victory = false
			four_consecutive = []
			4.times do
				four_consecutive << @current_player.piece
			end
			#vertical
			@state.transpose.each {|col|
				0.upto(COLUMNS-4) do |i|
					victory = true if col[i..i+3] == four_consecutive
				end
			}
			#horizontal
			@state.each {|row|
				0.upto(COLUMNS-4) do |i|
					victory = true if row[i..i+3] == four_consecutive
				end
			}
			@state.each_with_index { |_,r_i|
				next if r_i > ROWS - TO_CONNECT
				0.upto(COLUMNS - 4) do |i|
					diagonal_tl = []
					diagonal_tr = []

					#diagonal-bl_to_tr
					if i >= TO_CONNECT - 1
						0.upto(3) do |j|
							diagonal_tr << @state[r_i + j][i - j]
						end
						victory = true if diagonal_tr == four_consecutive
					end
				 	#diagonal-tl_to_br
					if i <= COLUMNS - TO_CONNECT
						0.upto(3) do |k|
							diagonal_tl << @state[r_i + k][i + k]
						end
						victory = true if diagonal_tl == four_consecutive
					end
				end
			}
			victory
		end

	end

	class Game

		attr_accessor :board

		def initialize
			main
		end

		def make_player
			puts "What is your name?"
			name = gets.chomp
			begin
				puts "Choose a piece (1 char)"
				piece = gets.chomp
				raise ArgumentError if piece.length > 1
			rescue
				puts "Invalid input!"
				retry
			end
			Player.new(name,piece)
		end

		def main
			puts "Welcome to Connect 4!"
			puts "Player 1 please enter your information:"
			player1 = make_player
			puts "Player 2 please enter your information:"
			player2 = make_player
			@board = Board.new([player1,player2],Board.empty_state)
			#begin game_loop
			loop do
				begin
					@board.print_state
					puts "#{@board.current_player.name}'s turn. Pick a column"
					column = gets.chomp.to_i
					unless column.is_a? Integer
						raise ArgumentError
					else
						@board.make_move(column)
						if @board.victory?
							@board.print_state
							puts "Game over. #{@board.current_player.name} wins!"
							break
						end
						@board.swap_players
					end
				rescue
					puts "Invalid input!"
					retry
				end
			end
		end
	end

# end