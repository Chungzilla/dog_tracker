require 'sinatra'
require 'sinatra/activerecord'

require './models/dog.rb'
require './models/owner.rb'

set :database, {adapter: "postgresql", database: "dog_owners2"}

get '/' do

    erb :index
end

get '/owners' do
    @all_owners = Owner.all
    erb :owners
end

get '/owners/:id/dogs' do
    specific_owner_id = params[:id]
    @owners_dog = Owner.find(specific_owner_id).dogs
   erb :owners_dog
end

get '/dogs' do
   @all_dogs = Dog.all
   erb :dogs 
end

get '/dogs/:id' do
    dog_id = params[:id]
    @specific_dog = Dog.find(dog_id)
    erb :specific_dogs
end
