require_relative 'services/csv_object'

class Cookbook
  def initialize(csv_file_path)
    @filepath = csv_file_path
    @recipes = []
    CSVObject.read(@filepath, @recipes)
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    write_csv
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    write_csv
  end

  def complete(index)
    @recipes[index].done!
    write_csv
  end

  private

  def write_csv
    CSVObject.write(@filepath, @recipes)
  end
end
