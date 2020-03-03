# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'nokogiri'
require 'better_errors'
require 'open-uri'
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
  url = "https://www.myrecipes.com/search?q=#{@search_term}"
  doc = Nokogiri::HTML(open(url), nil, 'utf-8')
  @titles = doc.css('.search-result-title-link-text').first(5).map(&:text).map(&:strip)
  @descriptions = doc.css('.search-result-description').first(5).map(&:text).map(&:strip)

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
