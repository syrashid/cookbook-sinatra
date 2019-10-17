require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require 'open-uri'
require_relative 'app/cookbook'
require_relative 'app/recipe'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

csv_file   = File.join(__dir__, 'recipes.csv')
cookbook   = Cookbook.new(csv_file)

get '/' do
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/recipes' do
  recipe = Recipe.new(params[:recipeName], params[:recipeDescription])
  cookbook.add_recipe(recipe)
  redirect '/'
end

post '/delete-recipe/:index' do
  cookbook.remove_recipe(params[:index].to_i)
  redirect '/'
end

post '/complete-recipe/:index' do
  cookbook.complete(params[:index].to_i)
  redirect '/'
end

