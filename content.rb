require "redis"
module Content

  $redis = Redis.new(:host => "localhost", :port => 6379, :db => 15)
end
