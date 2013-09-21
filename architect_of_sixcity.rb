# Architect of SixCity

# Submitted By:
# tarvit

# Difficulty:
# Hard

# Tags:
# algorithm, math, random, optimization

# Instructions:
#    You are an architect of SixCity. SixCity's architecture is quite special. It has unbreakable rules. There are only 6 types of buildings: Shop, Gym, Theatre, Restaurant, Club & Office. There are 6 buildings of these types in the city. Geographically, SixCity is a square 6x6. Basically, it is 36 cells with buildings inside. Also, there are 6 districts in SixCity, and each district includes 6 buildings. Districts may take on interesting forms.
# However, the headache you have as architect are the rules of a building's location. Each row, column, and district of the city should contain buildings of each type. Now you have a map with districts, and a few buildings of different types (call them A,B,C,D,E,F) already located there. You should find what building should stay inside each empty cell.
# You should implement class Solver. The Solver constructor receives districts (a matrix of district coordinates) and buildings (a hash with a building name as a key, and coordinates as a value). Use this data to implement the solve method to return a matrix of letters A,B,C,D,E,F.

# Hint: You may use helpers defined in the code below.
# Note: There is ZeegsCity with the same problem but another input data. You should solve the architecture for it too in order to pass this task.
# Hidden Code:
# There is hidden code with assertions that is also being run to test out your code.

gem 'minitest'

require 'minitest/autorun'
require 'minitest/pride'

module Setup
  def districts
    districts = []
    districts << [ [0,0] , [0,1] , [0,2] , [0,3] , [0,4] , [1,1] ]
    districts << [ [1,2] , [1,3] , [1,4] , [1,5] , [0,5] , [2,3] ]
    districts << [ [1,0] , [2,0] , [2,1] , [2,2] , [3,0] , [3,2] ]
    districts << [ [2,4] , [2,5] , [3,5] , [4,4] , [4,5] , [5,5] ]
    districts << [ [3,1] , [3,3] , [3,4] , [4,1] , [4,2] , [4,3] ]
    districts << [ [4,0] , [5,0] , [5,1] , [5,2] , [5,3] , [5,4] ]
  end

  def buildings
    buildings = {
      'A' => [0,0],  'B' => [1,4],  'C' => [3,3],
      'D' => [4,4],  'E' => [5,2],  'F' => [5,3],
    }
  end
end

class Array
  def i; self[0]; end
  def j; self[1]; end
end

module Helper
  STREET_LENGTH = 6
  ROW = (0..(STREET_LENGTH-1))
  def iterate(obj=nil, &block)
    ROW.each { |i|
      ROW.each { |j| block.(i,j, obj) }
    }
    obj
  end
end

class Solver
  include Helper

  attr_accessor :grid, :districts, :buildings, :possibles, :letters_solved

  CHARS   = %w{. ` - + , *}
  LETTERS = ('A'..'F').to_a

  def rows
    ROW.map {|i| ROW.map{|j| [i,j] } }
  end

  def cols
    ROW.map {|i| ROW.map {|j| [j,i] } }
  end

  def district(i, j)
    # returns the correct district
    districts.detect do |distr|
      distr.include?([i,j])
    end
  end

  def filled?(i, j)
    !!(grid[i][j] =~ /^[A-F]$/)
  end

  def fill(pos, letter)
    unless filled?(pos.i, pos.j)
      # puts letters_solved
      # puts self.to_s
      # puts
      @letters_solved += 1
      grid[pos.i][pos.j] = letter
      possibles[pos.i][pos.j] = [letter]
      update_possibles
    end
  end

  def initialize(districts, buildings)
    @grid      = ROW.map { ROW.map {"."} }
    @possibles = ROW.map { ROW.map {LETTERS.dup} }
    @districts = districts
    @buildings = buildings
    @letters_solved = 0

    initialize_districts
    initialize_buildings
  end

  def initialize_districts
    districts.each_with_index do |district, index|
      district.each do |pos|
        grid[pos.i][pos.j] = CHARS[index]
      end
    end
  end

  def initialize_buildings
    buildings.each do |letter, pos|
      grid[pos.i][pos.j] = letter.downcase
    end
  end

  def update_buildings
    buildings.each do |letter, pos|
      fill(pos, letter)
    end
  end

  def update_possibles
    # delete from rows, cols, and districts
    iterate do |i, j|
      if filled?(i, j)
        letter = grid[i][j]
        rows[i].each        {|pos| delete_possibility(pos, letter) unless pos.j == j}
        cols[j].each        {|pos| delete_possibility(pos, letter) unless pos.i == i}
        district(i, j).each {|pos| delete_possibility(pos, letter) unless pos.i == i && pos.j == j}
      end
    end

    filter_possibles
  end

  def filter_possibles
    # see if only one letter exists among each row, col, district
    LETTERS.each do |letter|
      rows.each      {|set| filter_set(set, letter) }
      cols.each      {|set| filter_set(set, letter) }
      districts.each {|set| filter_set(set, letter) }
    end
  end

  def filter_set(set, letter)
    times_found = 0
    pos_found = []
    set.each do |pos|
      if possibles[pos.i][pos.j].include?(letter)
        times_found += 1
        pos_found = pos
      end
    end

    if times_found == 1 && !filled?(pos_found.i, pos_found.j)
      # puts "#{pos_found}: #{letter}"
      fill(pos_found, letter)
    end
  end

  def delete_possibility(pos, letter)
    possibilities = possibles[pos.i][pos.j]

    if possibilities.size > 1
      possibilities.delete(letter)

      if possibilities.size == 1
        fill(pos, possibilities.first)
      end
    end
  end

  def solve
    update_buildings
    grid
  end

  def to_s
    grid.map {|row| row.join(" ")}.join("\n")
  end

  def possibles_to_s
    possibles.map do |row|
      row.map do |letters|
        letters.join("").rjust(6)
      end.join("  ")
    end.join("\n")
  end
end


class SixCityTest < MiniTest::Test
  include Setup

  # def initialize
  # end

  def test_solver_works
    answer = [["A", "E", "B", "D", "C", "F"],
              ["E", "F", "C", "A", "B", "D"],
              ["B", "C", "D", "E", "F", "A"],
              ["F", "D", "A", "C", "E", "B"],
              ["C", "A", "F", "B", "D", "E"],
              ["D", "B", "E", "F", "A", "C"]]

    res =  Solver.new(districts, buildings).solve
    assert_equal res, answer
  end

  # def yo
  #   solver = Solver.new(districts, buildings)
  #   # p solver.rows
  #   # p solver.cols
  #   # p solver.district(4,1)
  #   # p solver.filled?(5,4)
  #   # p solver.filled?(1,0)
  #   puts solver
  #   # puts solver.possibles_to_s

  #   solver.solve
  #   puts solver
  #   puts solver.letters_solved
  # end
end

# SixCityTest.new.yo