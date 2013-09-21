# Battleship

# Submitted By:
# tarvit

# Difficulty:
# Medium

# Tags:
# arithmetic, rand, game

# Instructions:
# Assume you are a shooter on a battleship. You are surrounded by enemy's ships. You know that enemy stays inside area 10x10. An enemy's submarine takes 5 cells in a target area. You should play and win 25 rounds of the game. Each round begins on a new blank board with a new random position of enemy's submarine. You will have only 20 shots per one round. You win a round if at least one of your 20 shots strikes an enemy.Implement shot method which returns array with two values: x,y coordinates of a new target cell.

gem 'minitest'

require 'minitest/autorun'
require 'minitest/pride'

class Shooter
  def shot
    @index ||= -1
    if @choices.nil?
      @choices = []
      (0..9).each { |n| @choices << [n, n] }
      (0..4).each { |n| @choices << [n, n+5] }
      (0..4).each { |n| @choices << [n+5, n] }
    end
    @index += 1
    @choices[@index]
  end
end

class BattleShip
  SIZE = 10
  SUBMARINE_PART = '*'
  ROW = 0..(SIZE-1)

  def initialize(shooter)
    @shooter = shooter
    @board = (ROW.map{|r| ROW.map{|e|'.'} })
    # p @board
    enemy_arrives
  end

  def enemy_arrives
    x,y = rand(SIZE), rand(SIZE)
    direction = [[0,1],[1,0]].sample.map{|x| x*[1,-1].sample}
    dx, dy = x+direction[0]*4, y+direction[1]*4
    direction.map!{|x| x*(-1)} unless(ROW.include?(dx) && ROW.include?(dy))
    0.upto(4){|i| @board[x+direction[0]*i][y+direction[1]*i] = SUBMARINE_PART }
  end

  def play_round
    1.upto(20) do
      coords = @shooter.shot
      return :hit if @board[coords.first][coords.last] == SUBMARINE_PART
    end
    :miss
  end
end

class BattleShipGame
  def self.play_all_rounds(rounds_count)
    results = []
    1.upto(rounds_count) do
      results << BattleShip.new(Shooter.new).play_round
    end
    results
  end
end


class BattleShipTest < MiniTest::Test
  def test_all_hits
    assert_equal BattleShipGame.play_all_rounds(25), [:hit]*25
  end
end