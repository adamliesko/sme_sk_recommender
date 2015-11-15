require 'mysql2'
require 'redis'

$redis = Redis.new(host: 'localhost', port: 6379, db: 15)

$db = Mysql2::Client.new(host: 'localhost', database: 'sme', username: 'root')
module CooccurrenceSimilarityEstimator
  ## create item: cookie1, cookie2 sets
  # chceme odstranit anonymneho usera 0
  # def create_item_sets_of_users
  #   results = $db.query("SELECT distinct(sme_id) FROM vi_train")
  #   results.each do |sme_id_row|
  #     sme_id = sme_id_row["sme_id"]
  #     cookies = $db.query("SELECT distinct(cookie) FROM vi_train where sme_id = #{sme_id} and cookie != 0")
  #     cookie_ids = []
  #     cookies.each { |row| cookie_ids << row["cookie"] }
  #     $redis.sadd "sme_id:#{sme_id}", cookie_ids if cookie_ids.any?
  #   end
  # end
  #
  # def create_user_sets_of_items
  #
  # end
  #
  # def compute_similarity_of_items
  #   results = $db.query("SELECT distinct(sme_id) FROM vi_train")
  #   no_of_users = $db.query("SELECT count(distinct(cookie)) as count FROM vi_train").first["count"]
  #   result_sme_ids = []
  #   results.each { |row| result_sme_ids << row["sme_id"] }
  #
  #   result_sme_ids.permutation(2).each do |outer, inner|
  #     # TODO user multi call
  #     #number_of_inner_members = $redis.scard "sme_id:#{inner}"
  #     #number_of_outer_members = $redis.scard "sme_id:#{outer}"
  #     interesction = $redis.sinter "sme_id:#{outer}", "sme_id:#{inner}"
  #     similarity =  1 - (interesction.size / (no_of_users.to_f))
  #     if similarity != 1
  #        $redis.zadd "similarity:#{outer}" , similarity, inner
  #        puts "#{outer}:#{inner} >> #{similarity}"
  #     end
  #   end
  # end

  def self.spark_item_similarity_input
    item_users_pairs = $db.query('SELECT sme_id, cookie FROM vi_train where cookie !=0')
    count = 0
    open('user_clicks', 'w') do |f|
      item_users_pairs.each do |pair|
        f.puts "#{pair['cookie']},#{pair['sme_id']}"
        count += 1
        puts count
      end
    end
  end

  def self.load_similarities_into_redis
    open('/Users/Adam/knn-rec/item_similarities_out/similarity-matrix/part-00000', 'r') do |f|
      f.readlines.each do |line|
        sme_ids = line.to_s.split(' ')
        sme_id = sme_ids.shift

        sme_ids.each do |similarity|
          similar_sme_id, sim = similarity.split(':')
          $redis.zadd "sme_similarity:#{sme_id}", sim, similar_sme_id
        end
      end
    end
  end
end

# load_similarities_into_redis
# spark_item_similarity_input

# create_item_sets_of_users
# compute_similarity_of_items
# create_user_sets_of_items
# do intersection with each other item and count the similarity

# aggregate items

# item 1 je % podobny itemu 2

# ziskam podobnost itemov na zaklade spravania pouzivatelov

# Vsetky userove itemy, najdem im najpodobnejsie  - pre kazdy napr 3 , scitam .. bude mat 500 itemov, teraz tieto itemy
