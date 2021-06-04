require "./load_data"
require "sinatra/json"


test =  JSON.parse(LoadData.get)["records"].map do
  |rec| rec["fields"]
end.to_h{ |r| [r["Name"],r["Lien Cloudinary"]]  }.compact

print test
