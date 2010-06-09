require 'yaml'
require 'treetop'
require 'alchemist'

FOOD_LIST = YAML.load_file("food_list.yml")
MEAL_DEFINITION = YAML.load_file("meal_definitions.yml")
DAYS = ["monday","tuesday","wednesday","thursday","friday","saturday","sunday"]
MEAL_SORTING = ['breakfast','morning snack','lunch','afternoon snack','dinner','evening snack']

def each_meal o
  MEAL_SORTING.each do |meal|
    yield meal, o[meal]
  end
end

def generate_day day_index
  ingredients = {}
  MEAL_DEFINITION.each do |meal, days|
    day = days[day_index]
    day.each do |food_category|
      cat = FOOD_LIST[food_category]
      items = cat["any"]
      items.update(cat[meal]) if cat.include? meal
      item = items.keys.choice
      ingredients[meal] = [] unless ingredients.include? meal
      ingredients[meal] << [item, items[item]]
    end
  end
  ingredients
end

def generate_week
  week = []
  (0...7).each do |i|
    week << generate_day(i)
  end
  week
end

def generate_shopping_list week
  shopping_list = {}
  week.each do |day|
    each_meal(day) do |meal, ingredients|
      ingredients.each do |k,v|
        if shopping_list.include? k
          shopping_list[k] += parse_measurement(v)
        else
          shopping_list[k] = parse_measurement(v)
        end
      end
    end
  end
end

def parse_measurement value
  
end

if __FILE__ == $0
  week = generate_week
  week.each_with_index do |day, i|
    puts "#{DAYS[i]}: "
    each_meal(day) do |meal, ingredients|
      puts "\t#{meal}: "
      ingredients.each do |k,v|
        puts "\t\t#{v} #{k}"
      end
    end
  end
      
end
