require 'rubygems'
require 'bundler'
require "sinatra/json"

Bundler.require


NAME_AND_PHOTO = {
  "Agathe" => "/image/upload/v1573665459/team/Agathe.jpg",
  "Raphael" => "/image/upload/v1573665459/team/raphael.jpg",
  "Marine" => "/image/upload/v1573665459/team/Marine.jpg",
  "Helene" => "/image/upload/v1573665459/team/Helene.jpg",
  "Matthieu Taverana" => "/image/upload/v1573665459/team/matthieu-taverna.jpg",
  "Benjamin" => "/image/upload/v1573665459/team/Benjamin.jpg"
}

class SessionStore
  @sessions = {}

  def self.get(id)
    dump = @sessions[id]
    if dump
      GuessWho::Session.load(dump)
    else
      session = GuessWho::Session.new(NAME_AND_PHOTO)
      put(id, session)
      session
    end
  end

  def self.put(id, session)
    dump = session.dump
    @sessions[id] = dump
  end

  def self.inspect
    @sessions.inspect
  end
end

get '/:player' do
  session = SessionStore.get(params['player'])
  candidate, photos = session.display_photo
  json(
    score: session.score,
    candidate: candidate,
    photos: photos,
    over: session.over?
  )
end

post '/:player' do
  session = SessionStore.get(params['player'])
  payload = JSON.parse(request.body.read)
  photo = payload["photo"]
  res = session.submit!(photo)
  SessionStore.put(params['player'], session)

  json(
    success: res
  )
end
