require "rubygems"
require "bundler"
require "sinatra/json"
require "sinatra/cors"
require "net/http"
require "./load_data"
Bundler.require
set :allow_origin, "*"
set :allow_methods, "GET,HEAD,POST,DELETE"
set :allow_headers, "content-type,if-modified-since"

NAME_AND_PHOTO = JSON.parse(LoadData.get)["records"].map do
  |rec| rec["fields"]
end.to_h{ |r| [r["Name"],r["Lien Cloudinary"]]}.compact

class SessionStore
  @sessions = {}
  def self.get(id, rounds)
    nbRounds = 5
    if rounds == 'true'
      nbRounds = NAME_AND_PHOTO.length
    end

    dump = @sessions[id]
    if dump
      GuessWho::Session.load(dump[:session])
    else
      session = GuessWho::Session.new(NAME_AND_PHOTO, rounds: nbRounds)
      put(id, session)
      session
    end
  end
  def self.put(id, session)
    dump = session.dump
    if @sessions[id]
      @sessions[id][:session] = dump
    else
      @sessions[id] = { session: dump, start: Time.now.to_i }
    end
  end
  def self.start(id)
    @sessions[id][:start]
  end
  def self.delete(id)
    @sessions.delete(id)
  end
  def self.inspect
    @sessions.inspect
  end
end

get "/:player/:rounds" do
  session = SessionStore.get(params["player"],params["rounds"])
  candidate, photos = session.display_photo
  answerPhoto = session.answer_photo
  json(score: session.score, candidate: candidate, photos: photos, over: session.over?, answerPhoto: answerPhoto)
end

post "/:player/:rounds" do
  player = params["player"]
  session = SessionStore.get(player,params["rounds"])
  payload = JSON.parse(request.body.read)
  photo = payload["photo"]
  answerPhoto = session.answer_photo
  res = session.submit!(photo) #true
  if session.over?
    start = SessionStore.start(player)
    post_to_zapier(player, session.score, Time.now.to_i - start)
  end
  SessionStore.put(params["player"], session)
  json(success: res, answerPhoto: answerPhoto)
end

delete "/:player" do
  SessionStore.delete(params["player"])
  halt 200
end

def post_to_zapier(name, score, time)
  uri = URI("https://hooks.zapier.com/hooks/catch/2061324/o6pa1q0/")
  req = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
  req.body = { name: name, score: score, time: time }.to_json
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
end
