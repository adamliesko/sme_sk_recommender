require '../connectors/elasticsearcher'
require '../connectors/mysql'
require '../connectors/redis'

module SimilarityEstimators
  module Content
    def self.load_articles
      path = '/Users/Adam/sme_content'
      Dir.foreach(path) do |filename|
        next if filename == '.' || filename == '..'
        text = File.read(File.join(path, filename))
        $es_client.index index: 'sme', type: 'articles', id: filename, body: { content: text }
      end
    end

    def self.load_similarities_redis
      items = $db.query('SELECT distinct(sme_id) from vi_train')
      items.each do |item|
        doc_id = item['sme_id']
        response = $es_client.search index: 'sme', body: built_mlt_query([doc_id])
        documents_to_store = response['hits']['hits'].map { |doc| { doc['_id'] => doc['_score'].to_f } }

        $redis.pipelined do
          documents_to_store.each do |similar_doc|
            $redis.zadd "sme_content_similarity:#{doc_id}", similar_doc.values[0].to_f, similar_doc.keys[0].to_s
          end
        end
      end
    end

    def self.built_mlt_query(doc_ids)
      docs = doc_ids.map { |doc_id| { _index: 'sme', _type: 'articles', "_id": doc_id } }
      {
        query: {
          more_like_this: {
            fields: [
              'content'
            ],
            docs: docs,
            min_term_freq: 1,
            max_query_terms: 30,
            stop_words: [
              'Twitter', 'Facebook', 'článok' 'cookie', 'Piano', 'predplatiteľ', 'predplatné'
            ],
            min_word_length: 2
          }
        },
        size: 30
      }
    end
  end
end

SimilarityEstimators::Content.load_similarities_redis
