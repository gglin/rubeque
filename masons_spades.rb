# Mason's Spades Problem

# Difficulty:
# Hard

# Tags:
# probability, arithmetic

# Instructions:
# In the game of spades, one player deals all 52 cards to four players so that each has 13 cards in his or her hand. The cards are shuffled prior to dealing, so that the distribution is random. The first play of the game is for each player to lay down his or her lowest club (where clubs are ordered from low to high as: 2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King, Ace).

# Once all four lowest clubs are on the table, the player who threw the highest of those four cards wins the cards (in other words, he or she wins the "trick"). If a player has no clubs, he or she must play a heart or a diamond, and that card has no chance of winning the trick. If a player has no clubs, no hearts, and no diamonds, then the player must play a spade, and will be guaranteed to win the trick.

# Write a class that has a method #winning_probability that will return the probability of a given card. Cards will be supplied in the format "2H" where two is the numeric value and H stands for hearts. Face value cards will be of the format "AC" for ace of clubs, or "KS" for king of spades, etc. Results must contain two significant digits after the decimal.

gem 'minitest'

require 'minitest/autorun'
require 'minitest/pride'

class MasonsSpadesTest  < MiniTest::Test
  def winning_probability
    
  end

  def test_2c
    assert_equal first_trick.winning_probability("2C"), 0.00
  end

  def test_10c
    assert_equal first_trick.winning_probability("10C"), 9.08
  end

  def test_Kc
    assert_equal first_trick.winning_probability("KC"), 3.50
  end

  def test_9c
    assert_equal first_trick.winning_probability("9C"), 11.87
  end

  def test_2s
    assert_equal first_trick.winning_probability("2S"), 0.00
  end

  def test_AH
    assert_equal first_trick.winning_probability("AH"), 0.00
  end
end
