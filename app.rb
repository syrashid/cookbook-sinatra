# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require_relative 'app/services/scraper_myrecipes'
require 'better_errors'

require_relative 'app/cookbook'
require_relative 'app/recipe'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
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

post '/search-results' do
  # Turn this into a service object
  @search_term = params[:recipeSearch]
  @recipes = ScrapeMyRecipes.call(params[:recipeSearch])
  erb :search
end

post '/add-internet-recipe' do
  recipe = Recipe.new(params[:recipeName], params[:recipeDesc])
  cookbook.add_recipe(recipe)
  redirect '/'
end

post '/add-user-recipe' do
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
