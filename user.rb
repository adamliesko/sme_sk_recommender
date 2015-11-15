

class User
  def initialize(user_id)
    @user_id = user_id
  end

  def visits
    $redis.smembers("user_visits:#{@user_id}")
  end

  def self.load_user_visits_to_redis
    results = $db.query('SELECT distinct(cookie) FROM vi_train WHERE cookie != 0')
    results.each do |cookie_row|
      cookie = cookie_row['cookie']
      smes = $db.query("SELECT distinct(sme_id) FROM vi_train where cookie = #{cookie} ")
      sme_ids = []
      smes.each { |row| sme_ids << row['sme_id'] }
      $redis.sadd "user_visits:#{cookie}", sme_ids if sme_ids.any?
    end
  end
end

puts
