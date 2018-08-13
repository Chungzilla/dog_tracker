require 'sinatra'
require 'sinatra/activerecord'
require './models/dog.rb'
require './models/owner.rb'
require './models/user.rb'
require 'sinatra/flash'
require 'giphy'

enable :sessions

Giphy::Configuration.configure do |config|
    config.api_key = ENV['GIPHY_API']
end

set :database, {adapter: "postgresql", database: "dog_owners2"}

get "/" do
    if session[:user_id]
      erb :signed_in_homepage
    else
      erb :signed_out_homepage
    end
end

#Displays sign in form
get '/sign-in' do
    erb :sign_in
end

#Responds to sign in form
post "/sign-in" do
    @user = User.find_by(username: params[:username])
  
    # checks to see if the user exists
    # and also if the user password matches the password in the db
    if @user && @user.password == params[:password]
        # this line signs a user in
        session[:user_id] = @user.id

        #Print a helpful message
        flash[:info] = "#{@user.username} has logged in"
        #redirect to homepage
        redirect '/'
    else 
        flash[:warning] = "Your username does not exist or your password is incorrect"
        redirect '/sign-in'
    end
end


#Displays Sign Up form
#   with fields for relevant user information like:
#   username, password
get "/sign-up" do
    erb :sign_up
end

post "/sign-up" do
 @user = User.create(
    username: params[:username],
    password: params[:password]
    )
    # this line does the signing in
    session[:user_id] = @user.id

    # lets the user know they have signed up
    flash[:info] = "Thank you for signing up"

    # assuming this page exists
    redirect "/"
end

  # when hitting this get path via a link
#   it would reset the session user_id and redirect
#   back to the homepage
get "/sign-out" do
    # this is the line that signs a user out
    session[:user_id] = nil
  
    # lets the user know they have signed out
    flash[:info] = "You have been signed out"
    
    redirect "/"
end
  
get '/users/:id/edit' do 
    if session[:user_id] == params[:id]
    #Access thier user profile edit page
    else
    #Redirect them and tell them they do not have access to edit other peoples profile pages
    end
end

get '/owners' do
    @all_owners = Owner.all
    erb :owners
end

get '/owners/:id' do
    #show all dogs that belong to a specific owner
    @specific_owner = Owner.find(params[:id])
    @owner_dogs = @specific_owner.dogs
    erb :specific_owner
end

get '/woof' do
    @gif = Giphy.random('dog')
    erb :woof
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

#New Action -> GET /resource/new
get '/dogs/new' do 
    erb :new_dog
end

#Show Action -> GET /resource/:id
get '/dogs/:id' do 
    @specific_dog = Dog.find(params[:id])
    erb :show_dog
end

#Create Action -> POST /resource 
post '/dogs' do 
    Dog.create(name: params[:name], breed: params[:breed], age: params[:age])
    redirect '/dogs'
end

#Edit Action -> GET /resource/:id/edit
get '/dogs/:id/edit' do
    @current_dog = Dog.find(params[:id])
    erb :edit_dog
end

#Update Action -> PUT/PATCH /resource/:id
put '/dogs/:id' do 
    @current_dog = Dog.find(params[:id])
    @current_dog.update(name: params[:name], breed: params[:breed], age: params[:age])
end

delete '/dogs/:id' do 
    @current_dog = Dog.find(params[:id])
    @current_dog.destroy
    redirect '/dogs'
end

private

def get_current_user 
    User.find(session[:user_id])
end

def get_specific_dog(id)
    Dog.find(id)
end
