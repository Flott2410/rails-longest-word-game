# require 'pry-byebug'
require 'byebug'
require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    letters = 10.times.map { ('a'..'z').to_a.sample(1) }
    @letters = letters.flatten
  end

  def score
    @guess = params[:word]
    @letters = params[:letters]
    @message = message(@guess, @letters)
    @score = calc(@guess, @letters)
  end

  private

  def english?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = open(url).read    # method to read the file
    word = JSON.parse(word_serialized)  # parse the file to work with it
    return word["found"]
  end
  # {"found":true,"word":"apple","length":5}

  def attempt_in_grid?(attempt, grid)
    attempt.chars.all? { |letter| grid.count(letter) >= attempt.count(letter) }
    # attempt_letter = attempt.upcase.chars # upcase just for rake - checks for UPCASED GRID
    # letter_in_grid = true
    # attempt_letter.map do |letter|
    #   letter_in_grid = grid.include?(letter) && letter_in_grid && grid.count(letter) >= attempt_letter.count(letter)
    # end
    # byebug
    # letter_in_grid
  end

  def message(attempt, grid)
    # generate message: #{result[:message]}
    # if result[:score] == 0 #{attempt} is not English or you used a letter twice."
    if attempt_in_grid?(attempt, grid) && english?(attempt)
      "Well done"
    elsif !attempt_in_grid?(attempt, grid)
      "Not in the grid"
    elsif !english?(attempt)
      "Not an English word"
    end
  end

  def calc(attempt, grid)
    if attempt_in_grid?(attempt, grid) && english?(attempt)
      score = attempt.size * attempt.size
    else
      0
    end
  end
end
