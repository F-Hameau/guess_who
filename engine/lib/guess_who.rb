# frozen_string_literal: true

require 'guess_who/version'

module GuessWho
  class Error < StandardError; end
  # Launch a game session
  class Session
    def initialize(name_and_photo, score: 0, used_names: [], rounds: nil, photos: nil, candidate: nil)
      @name_and_photo = name_and_photo
      @score = score
      @used_names = used_names
      @photos = photos
      @candidate = candidate
      @rounds = [rounds || name_and_photo.length].reject(&:nil?).min
      pick_candate_and_photos! if @photos.nil? && @candidate.nil?
    end

    def display_photo
      [@candidate, @photos] unless over?
    end

    def answer_photo
      return if over?

      @name_and_photo[@candidate]
    end

    def submit!(photo)
      return if over?

      success = (photo == @name_and_photo[@candidate])
      @score += 100 if success
      @used_names << @candidate
      pick_candate_and_photos!
      success
    end

    def score
      @score
    end

    def over?
      @used_names.length >= @rounds
    end

    def dump
      {
        name_and_photo: @name_and_photo,
        used_names: @used_names,
        score: @score,
        photos: @photos,
        candidate: @candidate,
        rounds: @rounds
      }
    end

    def self.load(dump)
      GuessWho::Session.new(dump[:name_and_photo], score: dump[:score], used_names: dump[:used_names], photos: dump[:photos], candidate: dump[:candidate], rounds: dump[:rounds])
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
