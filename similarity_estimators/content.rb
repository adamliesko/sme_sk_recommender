require 'connectors/elasticsearcher'

module SimilarityEstimators
  module Content

    def self.load_articles
      path = '/Users/Adam/sme_content'

      Dir.foreach(path) do |filename|
        next if filename == '.' or filename == '..'
        text = File.read(File.join(path, filename))
        puts "#{filename}"
        $es_client.index index: 'sme', type: 'articles', id: filename, body: {content: text}
      end
    end

    def self.load_top_similarities_into_redis

    end



  end
end




