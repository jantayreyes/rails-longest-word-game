require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array('A'..'Z').shuffle[0..9]
  end
  
  def score
    session[:score] = session[:score] || 0
    @letters = params[:letters]
    @word = params[:word].upcase
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    @a_letters = @letters.gsub!(/\s+/, '').split("")
    @a_word = @word.split("")

    byebug

    if is_english?(@word) && @a_word.length <= @a_letters.length && (@a_letters & @a_word).size == @a_word.size
      @done = "Contragulations! #{@word} is a valid English World!"
      session[:score] += @word.length
    elsif (@a_letters & @a_word).empty?
      @done = "Sorry but #{@word} can't be built out of #{@a_letters}"
      session[:score] -= 2
    elsif !is_english?(@word)
      @done = "Sorry but #{@word} does not seem to be a valid English word..."
      session[:score] -= 1
    end
    @score = session[:score]
  end

  def is_english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = open(url).read
    json= JSON.parse(response)
    json["found"]

  end

end

