# frozen_string_literal: true

require 'guess_who/version'

module GuessWho
  class Error < StandardError; end
  # Launch a game session
  class Session
    def initialize(name_and_photo)
      @name_and_photo = name_and_photo
      @photos = @name_and_photo.values
      @score = 0
      @used_names = []
      @photo = nil
    end

    def display_photo
      name_and_photo_unused = @name_and_photo.reject { |k, _| @used_names.include?(k) }
      name, @photo = name_and_photo_unused.to_a.sample(1).to_h.flatten
      photos = @photos.sample(8)
      unless photos.include?(@photo)
        photos.shift
        photos << @photo
      end
      @used_names << name
      [name, photos.shuffle]
    end

    def submit!(photo)
      (photo == @photo).tap do |res|
        @score += 100 if res
      end
    end

    def score
      @score
    end
  end
end
