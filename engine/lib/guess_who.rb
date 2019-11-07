# frozen_string_literal: true

require 'guess_who/version'

module GuessWho
  class Error < StandardError; end
  # Launch a game session
  class Session
    def initialize(name_and_photo, score: 0, used_names: [], photos: nil, candidate: nil)
      @name_and_photo = name_and_photo
      @score = score
      @used_names = used_names
      @photos = photos
      @candidate = candidate
      pick_candate_and_photos! if @photos.nil? && @candidate.nil?
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

    def dump
      {
        name_and_photo: @name_and_photo,
        used_names: @used_names,
        score:  @score,
        photos: @photos,
        candidate: @candidate
      }
    end

    def self.load(dump)
      GuessWho::Session.new(dump[:name_and_photo], score: dump[:score], used_names: dump[:used_names], photos: dump[:photos], candidate: dump[:candidate])
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

# sinatra : http://sinatrarb.com/intro.html
