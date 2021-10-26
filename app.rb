require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative 'models/cookbook'
require_relative 'models/recipe'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end



get '/' do
  csv_file   = File.join(__dir__, 'data/recipes.csv')
  @@cookbook   = Cookbook.new(csv_file)
  @@recipes = @@cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post "/new_recipe" do
  recipe = Recipe.new(params['name'], params['description'], params['rating'], params['prep-time'])
  @@cookbook.add_recipe(recipe)
  redirect "/"
end

post "/destroy" do
  index = params['index'].to_i
  @@cookbook.remove_recipe(index)
  redirect "/"
end

# get '/about' do
#   erb :about
# end

# get '/team/:username' do
#   puts params[:username]
#   "The username is #{params[:username]}"
# end

# get '/' do
#   @usernames = [ 'ssaunier', 'Papillard' ]
#   erb :index
# end
