require "redis"

$redis = Redis.new(:host => "localhost", :port => 6379, :db => 15)
