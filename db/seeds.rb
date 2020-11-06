require 'open-uri'
require 'nokogiri'

puts 'creating 1 User'
  user1= User.new(email: 'test@test.com' , password: '123456')
  user1.save!

puts 'User created'

def seed_750g
  base_url = "https://www.750g.com"
  page = '?page=2' || ''
  url = "https://www.750g.com/categorie_plats.htm#{page}"

  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)

  html_doc.search('.u-link-wrapper').each do |element|
    puts 'creation recette'
    recette = Recipe.new
    url_recette = "#{base_url}#{element.attribute('href').value}"
    html_file_recette = open(url_recette).read
    html_doc_recette = Nokogiri::HTML(html_file_recette)
    # recette name
    recette.name = html_doc_recette.search('.u-title-page').text.strip
    # recette complexity / prix
    recette.complexity = html_doc_recette.search('.recipe-info-item')[1].text.strip
    p html_doc_recette.search('.recipe-info-item')[1].text.strip
    p recette.complexity
    recette.price = html_doc_recette.search('.recipe-info-item')[2].text.strip
    # recette description
    recette.description = html_doc_recette.search('.recipe-chapo p').text.strip
    # recette base_quantity
    recette.base_quantity = html_doc_recette.search('.ingredient-variator-label').text.strip.split(" ")[0]
    # recette unit
    recette.unit = html_doc_recette.search('.ingredient-variator-label').text.strip.split(" ")[1]
    # recette prep_time et cook_time
    recette.prep_time = html_doc_recette.search('.recipe-steps-info-item time')[0].text.strip || '0min'
    recette.cook_time = html_doc_recette.search('.recipe-steps-info-item time')[1].nil? ? '0min' : html_doc_recette.search('.recipe-steps-info-item time')[1].text.strip

    recette.save!
    puts 'recette done'
    puts 'creation step associes'
    # step description et number
    html_doc_recette.search('.grid .recipe-steps-item').each do |element|
      step = Step.new(recipe: recette)
      step.number = element.search('.recipe-steps-position').text.strip
      step.description = element.search('p').text.strip
      step.save!
    end
    puts 'les steps associé done'
    #  ingredient name
    puts 'creation ingredient et quantite associe avec:'
    html_doc_recette.search('.recipe-ingredients-item').each do |element|
      if element.search('img').attribute('alt') != nil && element.search('.recipe-steps-position').attribute('alt') != ""
        ingredient = unique_ingredient(element.search('img').attribute('alt').value, element.search('.recipe-ingredients-item-label').text.strip)
        quantity = Quantity.new(recipe: recette, ingredient: ingredient)
        number_and_unit_quantity(element.search('.recipe-ingredients-item-label').text.strip, quantity)
      else
        ingredient = unique_ingredient(ingredient_in_string(element.search('.recipe-ingredients-item-label').text.strip))
        quantity = Quantity.new(recipe: recette, ingredient: ingredient)
        number_and_unit_quantity(element.search('.recipe-ingredients-item-label').text.strip,quantity)
      end
    end
  #  BUG faire une methode pour type ingredient selon le mot ' sel = epicrie , courgette = legume etc
  end
end

def ingredient_in_string string
  array_of_string = string_with_de string.split(' ')
  if array_of_string.first.to_f == 0
    return string
  elsif ['g', 'c.', 'verre', 'verres', 'cl', 'kit', 'pincée', 'petite','poignée', 'poignées',  'botte','gousse','gousses'].include?(array_of_string[1]) && array_of_string.first.to_f != 0
    if array_of_string[1] == 'c.'
      array_of_string.shift(5)
      return array_of_string.join(" ")
    elsif array_of_string[1] == 'petite'
      array_of_string.shift(4)
      return array_of_string.join(" ")
    else
      array_of_string.shift(3)
      return array_of_string.join(" ")
    end
  elsif array_of_string.first.to_f != 0
    array_of_string.shift(1)
    return array_of_string.join(" ")
  end
end

def string_with_de array
  new_array = []
  array.each_with_index do |word, index|

    if  (word[0] == "d" && word[1] == "'") && ['g', 'c.', 'verre', 'verres', 'cl', 'kit', 'pincée', 'petite','poignée', 'poignées',  'botte','gousse','gousses' ].include?(array[index-1])
      new_array << 'de'
      new_array << word.gsub("d'","")
    else
      new_array << word
    end
  end

  return new_array
end

def type_ingredient string
  #  a   definir selon les ingredients clé
end

def unique_ingredient(string1, string2 = string1)
  exist_ingredient = Ingredient.where(name: "#{string1}").empty?
  if exist_ingredient
    puts "création d'un nouvel ingredient"
    ingredient = Ingredient.new(name: "#{string1}", unit: "#{unit_ingredient string2}" || "")
    ingredient.save!
    puts 'New ingredient saved'
    return Ingredient.last
  else
    puts "Ingredient already exists"
    return Ingredient.where(name: "#{string1}").first
  end

end

def number_and_unit_quantity(string, quantity)
  if string.split(' ').first.to_f != 0
    number = string.split(' ').first.gsub(',','.').to_f
    unit = unit_ingredient string
  end
  quantity.number = number
  quantity.unit =  unit
  quantity.save!
  puts 'quantity saved'
end

def unit_ingredient string
  if ['g', 'c.', 'verre', 'verres', 'cl', 'kit', 'pincée', 'petite','poignée', 'poignées',  'botte','gousse','gousses'].include?(string.split(' ').second)
      if string.split(' ').second == 'c.'
        return 'c. à s.'
      elsif string.split(' ').second == 'petite'
        return 'petite poignée'
      else
        return string.split(' ').second
      end
  else
    return ''
  end
end

puts 'creating recipe, step , ingredients, quantities '


seed_750g

puts 'seed finished'
