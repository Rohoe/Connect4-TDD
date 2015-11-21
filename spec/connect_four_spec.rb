require 'spec_helper'

describe "Connect_four" do

	describe Coord do
		before :each do
			@coord = Coord.new(1,2)
		end

		describe '.new' do
			it "takes in two parameters" do
				expect(@coord).to be_an_instance_of(Coord)
			end

			it "throws errors for wrong number of arguments" do
				expect {Coord.new(1)}.to raise_error ArgumentError
			end
		end

	end

	describe Player do

		before :each do
			@player = Player.new("Bob", "O")
		end

		describe '.new' do
			it "takes in two parameters" do
				expect(@player).to be_an_instance_of(Player)
			end

			it "throws errors for wrong number of arguments" do
				expect {Player.new("Alice")}.to raise_error ArgumentError
			end

			it "throws errors for invalid arguments" do
				expect {Player.new("Alice","ABC")}.to raise_error ArgumentError
			end
		end

	end

	describe Board do

		let(:empty_table) {
			row = Array.new(Board::COLUMNS)
			table = []
			Board::ROWS.times do
				table << row
			end
			table
		}

		let(:empty_table_string) {
			row = ""
			table = ""
			Board::COLUMNS.times do
				row = row + "* "
			end
			row = row + "\n"
			Board::ROWS.times do
				table = table + row
			end
			table
		}

		before :each do
			@player1 = Player.new("Bob","O")
			@player2 = Player.new("Alice","X")
			@state = Board.empty_state
			@board = Board.new([@player1,@player2], @state)
		end

		describe "#get_current_player" do
			it {expect(@board.current_player).to be(@player1)}
		end

		describe "#empty_state" do
			it {expect(Board.empty_state).to eq(empty_table)}
		end

		describe "#to_s" do
			it {expect(@board.to_s).to eq(empty_table_string)}
		end

		describe ".new" do
			it {expect(@board).to be_an_instance_of Board}
		end

		describe "#set, #get" do
			it {
				@board.set(Coord.new(1,1))
				expect(@board.get(Coord.new(1,1))).to eq("O")
				@board.set(Coord.new(1,3))
				expect(@board.get(Coord.new(1,3))).to eq("O")
			}
		end

		describe "#make_move" do
			it "puts a new piece in the right place" do
				@board.make_move(1)
				@board.make_move(2)
				@board.make_move(2)
				expect(@board.get(Coord.new(1,Board::ROWS))).to eq("O")
				expect(@board.get(Coord.new(2,Board::ROWS))).to eq("O")
				expect(@board.get(Coord.new(2,Board::ROWS-1))).to eq("O")
			end

			it "throws an error when a column is full" do
				Board::ROWS.times do
					@board.make_move(1)
				end
				expect{@board.make_move(1)}.to raise_error ArgumentError
			end
		end

		describe "#swap_players" do
			it "swaps players correctly" do
				@board.swap_players
				expect(@board.current_player).to eq(@player2)
				@board.swap_players
				expect(@board.current_player).to eq(@player1)
			end
		end

		describe "#victory?" do
			it "detects the vertical win condition" do
				4.times do
					@board.make_move(1)
				end
				expect(@board.victory?).to eq(true)
			end

			it "detects the horizontal win condition" do
				1.upto(4) do |i|
					@board.make_move(i)
				end
				expect(@board.victory?).to eq(true)
			end

			it "detects the diagonal-tl win condition" do
				1.upto(4) do |i|
					@board.set(Coord.new(i,i))
				end
				expect(@board.victory?).to eq(true)
			end

			it "detects the diagonal-tr win condition" do
				1.upto(4) do |i|
					@board.set(Coord.new(i,Board::ROWS-i-1))
				end
				@board.print_state
				expect(@board.victory?).to eq(true)
			end
		end

	end

	describe Game do

	end

end
