# frozen_string_literal: true

class Recipe
  attr_reader :name, :description, :status

  def initialize(name, description, status = false)
    @name = name
    @description = description
    @status = status
  end

  def done!
    @status = true
  end
end
