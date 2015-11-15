require '../recommenders/cooccurrence'
require '../recommenders/content'

module Recommenders
  module Hybrid
    RECCOMMENDERS = ['Cooccurrence']

    # rozne agregacne strategie z aggregation_strategies
    def self.recommend_to_user(user_id)
      recommendations = {}
      RECCOMMENDERS.each do |recommender|
        recommender_class = Recommenders.const_get(recommender.to_sym)
        recommendations.merge! recommender_class.recommend_to_user(user_id, :nn)
      end
      remove_visited_items(User.new(user_id), recommendations)
    end

    private

    def self.remove_visited_items(user, recs, recs_count_wanted = 10)
      unseen_recs = recs.map { |key, _value| key } - user.visits
      return unseen_recs.first(recs_count_wanted) if unseen_recs.size >= recs_count_wanted
      recs # TODO: if we have weights, return some mix of seen / weights stuff
    end

    def self.normalize_recommendations(recs)

    end

    #strategies => :sum - sums weights per keys (neutral 0), :mul - multiplies weights (neutral 1), :random - random combinations of merge, :pick - pick one of the recommenders
    def self.merge_recommendations(_recommendations, _new_recommendations, _strategy = :sum)

    end
  end
end

puts Recommenders::Hybrid.recommend_to_user('12314471422346816')
