require 'open-uri'
require 'nokogiri'

base_url = "https://www.750g.com"
page = '?page=2' || ''
url = "https://www.750g.com/categorie_plats.htm#{page}"

html_file = open(url).read
html_doc = Nokogiri::HTML(html_file)

html_doc.search('.u-link-wrapper').each do |element|
  url_recette = "#{base_url}#{element.attribute('href').value}"
  html_file_recette = open(url_recette).read
  html_doc_recette = Nokogiri::HTML(html_file_recette)
  # recette name
  puts html_doc_recette.search('.u-title-page').text.strip
  # recette temps / complixity / prix
  html_doc_recette.search('.recipe-info-item').each do |element|
    puts element.text.strip
  end
  # recette description
  puts html_doc_recette.search('.recipe-chapo p').text.strip
  # recette base_quantity
  puts html_doc_recette.search('.ingredient-variator-label').text.strip.split(" ")[0]
  # recette base_quantity_unit
  puts html_doc_recette.search('.ingredient-variator-label').text.strip.split(" ")[1]
  # recette prep_time et cook_time
  html_doc_recette.search('.recipe-steps-info-item time').each do |element|
    puts element.text.strip
  end
  # step description et number
  html_doc_recette.search('.grid .recipe-steps-item').each do |element|
    puts element.search('.recipe-steps-position').text.strip
    puts element.search('p').text.strip
  end
  #  ingredient name
  html_doc_recette.search('.recipe-ingredients-item').each do |element|
    if element.search('img').attribute('alt') != nil && element.search('.recipe-steps-position').attribute('alt') != ""
      puts element.search('img').attribute('alt').value
    else
      # ici ingredient par defaut c'est pas bon , faire une methode qui trouve le bon mot
      puts element.search('.recipe-ingredients-item-label').text.strip
    end
  end
#  faire une methode pour type ingredient selon le mot ' sel = epicrie , courgette = legume etc
  # quantity number et unit :
#  attention faire les liaisons vers ingredient et recipe dans la method
  html_doc_recette.search('.recipe-ingredients-item-label').each do |element|
    number_and_unit_quantity element.text.strip
  end
end

def ingredient string
  #  a defénir selon les unité qu'on a
end

def type_ingredient string
  #  a   definir selon les ingredients clé
end

def unique_ingredient string
  exist_ingredient = Ingredient.where(name: "#{string}") || ''
  if exist_ingredient != ""
    puts "création d'un nouvel ingredient"
    ingredient = Ingredient.new(name: "#{string}")
    ingredient.save!
  end
end

def number_and_unit_quantity string #mettre l'ingredient et le recipe associé en param
  if string.split(' ').first.to_f != 0
    number = string.split(' ').first.gsub(',','.').to_f
    unit = ''
    if ['g', 'c.', 'verre', 'cl', 'kit'].include?(string.split(' ').second)
      if string.split(' ').second == 'c.'
        unit = 'c. à s.'
      else
        unit =  string.split(' ').second
      end
    end
  end
  quantity = Quantity.new(number: number, unit: unit)
  quantity.save!
end

    quantities
    t.integer "number"
    t.string "unit"
    t.bigint "recipe_id", null: false
    t.bigint "ingredient_id", null: false

# puts 'creating 1 User'
#   user1= User.new(email: 'test@test.com' , password: '123456')
#   user1.save!

# puts 'User created'
