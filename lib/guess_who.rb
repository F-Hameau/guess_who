require "guess_who/version"

module GuessWho
  class Error < StandardError; end
  class Session
    def initialize(name_and_photo)
      @name_and_photo = name_and_photo
      @score = 0
    end

    def display_photo
      name, @photo = @name_and_photo.first
      photos = @name_and_photo.values
      [name, photos]
    end

    def good_answer?(photo)
      (photo == @photo).tap do |res|
        @score += 100 if res
      end
    end

    def score
      @score
    end
  end
end
