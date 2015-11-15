require 'mysql2'
$db = Mysql2::Client.new(host: 'localhost', database: 'sme', username: 'root')
