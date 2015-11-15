require '../user'
require '../connectors/redis'
module Recommenders
  module Content
    MODE_PARAMS = { nn: 5, similarity: 0.5 }


    def self.recommend_to_user(user_id, mode = :nn, param = nil)
      param = MODE_PARAMS[mode] unless param
      user = User.new user_id
      send("#{mode}_recommendations", user.visits, param)
    end

    private

    # top n similarities per item
    def self.nn_recommendations(visits, top_nn = 5)
      similarities = []
      visits.each do |sme_id|
        sme_ids_and_sims = $redis.zrange "sme_content_similarity:#{sme_id}", top_nn, -1, with_scores: true
        similarities << Hash[sme_ids_and_sims]
      end
      recommendations =  similarities.inject { |memo, el| memo.merge(el) { |_k, old_v, new_v| old_v + new_v } } # sum partial_scores,
      Hash[recommendations.sort_by { |_k, v| -1 * v }]
    end

    # similarities > threshold
    def self.similarity_recommendations(visits, threshold = 0.5)
      similarities = []
      visits.each do |sme_id|
        sme_ids_and_sims = $redis.zrangebyscore "sme_content_similarity:#{sme_id}", threshold.to_s, '+inf', with_scores: true
        similarities << Hash[sme_ids_and_sims]
      end
      recommendations =  similarities.inject { |memo, el| memo.merge(el) { |_k, old_v, new_v| old_v + new_v } } # sum partial_score
      Hash[recommendations.sort_by { |_k, v| -1 * v }]
    end

  end
end


