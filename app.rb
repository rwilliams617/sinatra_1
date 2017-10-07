require 'sinatra'
require 'sqlite3'
require 'pry'
require './client'


class Bucket

  attr_accessor :id, :name, :url, :description

  def initialize(id:, name:, url:, description:)
    @id = id
    @name = name
    @url = url
    @description = description
  end


  # insert into buckets
  def save
    sql = "INSERT INTO buckets (id, name, url, description) VALUES (:id, :name, :url, :description)" 
    db = SQLite3::Database.new ("bucketlist.db")
    db.execute sql, :id => @id, :name => @name, :url => @url, :description => @description
  end

  # find a bucket by it's id using select
  def self.find(id)
    id = "SELECT id FROM buckets"
    db = SQLite3::Database.new ("bucketlist.db")
    db.execute id, :id => @id
  end

  # apply the changes using an update
  def update(changes)
    changes = "UPDATE buckets SET name = ? WHERE id = ?"
    db = SQLite3::Database.new ("bucketlist.db")
    db.execute changes, :name => @name, :id => @id
  end

  # delete the record 
  def delete
    delete = "DELETE FROM buckets WHERE name = ?"
    db = SQLite3::Database.new ("bucketlist.db")
    db.execute changes, :name => @name
  end
end


get "/" do
  db = SQLite3::Database.new('bucketlist.db')
  results = db.execute ('SELECT id, name, url, description from buckets')
  @buckets = results.map do |row|
    Bucket.new(:id => row[0], :name => row[1], :url => row[2], :description => row[3])
  end
  erb :index, :layout => :"layouts/main"	
end

get "/buckets/:id" do
	db = SQLite3::Database.new('bucketlist.db')
  results = db.execute('SELECT * from buckets WHERE id = ?')
  @id = results.map do |row|
    Bucket.new(:id => row[0])
  end
	erb :bucket, :layout => :"layouts/main"
end


post "/buckets" do
  db = SQLite3::Database.new('bucketlist.db')
  db.execute('INSERT INTO buckets (name, url, description) VALUES (?,?,?)',
  params[:item_name], params[:item_url], params[:item_description])
	redirect "/"
end


