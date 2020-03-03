# frozen_string_literal: true

require 'csv'
require_relative '../recipe'

class CSVObject
  def self.read(filepath, recipes)
    CSV.foreach(filepath) { |row| recipes << Recipe.new(row[0], row[1], row[2] == 'true') }
  end

  def self.write(filepath, recipes)
    csv_options = { col_sep: ',' }
    CSV.open(filepath, 'wb', csv_options) do |csv|
      recipes.each { |recipe| csv << [recipe.name, recipe.description, recipe.status] }
    end
  end
end
