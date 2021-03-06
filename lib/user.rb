require 'pg'
require_relative 'database_connection'

class User
  attr_reader :id, :first_name, :surname, :email, :password

  def initialize(id:, first_name:, surname:, email:, password:)
    @id = id
    @first_name = first_name
    @surname = surname
    @email = email
    @password = password
  end

  def self.authenticate(email:, password:)
    result = DatabaseConnection.query("SELECT * FROM users WHERE email = '#{email}'AND password = '#{password}'")
    return unless result.any?

    User.new(id: result[0]['id'], first_name: result[0]['first_name'], surname: result[0]['surname'], email: result[0]['email'], password: result[0]['password'])
  end

  # def self.all
  #   result = DatabaseConnection.query("SELECT * FROM users")
  #   result.map do |user|
  #     User.new(
  #       first_name: user['first_name'],
  #       surname: user['surname'],
  #       email: user['email'],
  #       password: user['password']
  #     )
  # end

  def self.create(first_name:, surname:, email:, password:)
    if ENV['RACK_ENV'] == 'test'
    connection = PG.connect dbname: "bnb_test"
    else
    connection = PG.connect dbname: "bnb"
    end

   result = connection.exec("INSERT INTO users (first_name, surname, email, password) VALUES ('#{first_name}', '#{surname}', '#{email}', '#{password}') RETURNING id, first_name, surname, email, password;")
   User.new(id: result[0]['id'], first_name: result[0]['first_name'], surname: result[0]['surname'], email: result[0]['email'], password: result[0]['password'] )
  end
end
