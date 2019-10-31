# frozen_string_literal: true

require 'guess_who/version'

module GuessWho
  class Error < StandardError; end
  # Launch a game session
  class Session
    def initialize(name_and_photo)
      @name_and_photo = name_and_photo
      @score = 0
      @used_names = []
      pick_candate_and_photos!
    end

    def display_photo
      [@candidate, @photos]
    end

    def submit!(photo)
      success = (photo == @name_and_photo[@candidate])
      @score += 100 if success
      @used_names << @candidate
      pick_candate_and_photos!
      success
    end

    def score
      @score
    end

    private

    def pick_candate_and_photos!
      @candidate = @name_and_photo.keys.reject { |name| @used_names.include?(name) }.sample(1).first
      photo = @name_and_photo[@candidate]
      photos = @name_and_photo.values.sample(8)
      unless photos.include?(photo)
        photos.shift
        photos << photo
      end
      @photos = photos.shuffle
    end
  end
end

# to do dump / load(class method)
# sinatra : http://sinatrarb.com/intro.html
