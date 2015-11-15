require 'distance_measures'

class KNNRecommender
  def initialize(data, options = {})
    @data = data
    @distance_measure = options[:distance_measure] || :euclidean_distance
    @k = options[:k]
  end

  def nearest_neighbours(input)
    find_closest_data(input)
  end

  def recommend_to_user(_user)
  end

  private

  def find_closest_data(input)
    calculated_distances = []

    @data.each_with_index do |datum, index| # Ye olde english
      distance = input.send(@distance_measure, datum)
      calculated_distances << [index, distance, datum]
    end

    calculated_distances.sort(&[1]).first(@k)
  rescue NoMethodError
    raise "Hey, that's not a measurement. Read the README for available measurements"
  end
end

# ziskam najpodobnejsich ludi
