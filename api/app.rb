require 'rubygems'
require 'bundler'
require "sinatra/json"
require "sinatra/cors"

Bundler.require

set :allow_origin, "*"
set :allow_methods, "GET,HEAD,POST,DELETE"
set :allow_headers, "content-type,if-modified-since"

NAME_AND_PHOTO = JSON.parse(File.read('./data/names_and_photos.json'))

class SessionStore
  @sessions = {}

  def self.get(id)
    dump = @sessions[id]
    if dump
      GuessWho::Session.load(dump)
    else
      session = GuessWho::Session.new(NAME_AND_PHOTO, rounds: 3)
      put(id, session)
      session
    end
  end

  def self.put(id, session)
    dump = session.dump
    @sessions[id] = dump
  end

  def self.delete(id)
    @sessions.delete(id)
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

  # if session.over?
  # push to zapier

  SessionStore.put(params['player'], session)

  json(
    success: res
  )
end

delete '/:player' do
  SessionStore.delete(params['player'])
  halt 200
end
