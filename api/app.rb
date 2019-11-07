require 'rubygems'
require 'bundler'
require "sinatra/json"

Bundler.require


  name_and_photo = {
      'François Hameau' => '/teams/francois.png',
      'David Ruyer' => '/teams/david.png',
      'Renaud Pestre' => '/teams/renaud.png'
    }

  session = GuessWho::Session.new(name_and_photo)

get '/' do
  candidate, photos = session.display_photo
  json(
    score: session.score,
    candidate: candidate,
    photos: photos
  )
end

post '/submit' do

end

