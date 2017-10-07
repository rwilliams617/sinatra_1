require 'sqlite3'
# include 'Bucket'

db = SQLite3::Database.new('bucketlist.db')

rows = db.execute <<-SQL 
          create table if not exists buckets (
           id integer primary key,
           name text,
           url text,
           description text
         );
        SQL


# puts rows
# puts rows.inspect