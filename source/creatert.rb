
require 'rubygems'
require 'sqlite3'

db = SQLite3::Database.new('HistoricalData')
db.execute('drop table rt')
db.execute('create table rt(id integer primary key, rate real, dt integer)')

p 'before get size'
size = db.execute('select max(id) from usdjpy')[0][0]

buff = 100000
i = 0
arr = db.execute("
    select year, month, day, hour, minutes, second
    from usdjpy where id = 0")[0]
    cur_time = Time.mktime(*arr)
    loop do
      p i.to_f / size
      break unless i + buff < size
      data = db.execute("
    select year, month, day, hour, minutes, second, bid
    from usdjpy
    where #{i} < id and id <= #{i += buff}")
    data.each do |d|
      old_time = cur_time
      rate = d.pop
      cur_time = Time.mktime(*d)
      dt = cur_time - old_time
      db.execute("insert into rt(rate, dt) values(#{rate}, #{dt})")
    end

    end




