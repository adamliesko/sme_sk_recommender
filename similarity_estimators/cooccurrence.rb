require '../connectors/mysql'
require '../connectors/redis'

module SimilarityEstimators
  module Cooccurrence
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

          puts sme_id
          sme_ids.each do |similarity|
            puts similarity
            similar_sme_id, sim = similarity.split(':')
            $redis.zadd "sme_similarity:#{sme_id}", sim.to_i, similar_sme_id.to_s
          end
        end
      end
    end
  end
end
