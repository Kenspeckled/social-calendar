require 'redis'
require 'sinatra/base'
require 'bcrypt'

class Admin < Sinatra::Base

  @redis = Redis.new

  def self.authenticate(email, password)
    user = @redis.hgetall("admin:#{email}")
    if user && user["password_salt"] && user["password_hash"] && user["password_hash"] == BCrypt::Engine.hash_secret(password, user["password_salt"])
      user
    end
  end

  def self.create(email, password)
    password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    @redis.hset("admin:#{email}", "email", email)
    @redis.hset("admin:#{email}", "password_salt", password_salt)
    @redis.hset("admin:#{email}", "password_hash", password_hash)
  end


end
