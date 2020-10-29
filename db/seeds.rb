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
  # recette titre
  puts html_doc_recette.search('.u-title-page').text.strip
  # recette temps / difficulte / prix
  html_doc_recette.search('.recipe-info-item').each do |element|
    puts element.text.strip
  end
  # recette description
  puts html_doc_recette.search('.recipe-chapo p').text.strip
  # puts element.text.strip
  # puts element.attribute('href').value
end

# puts 'creating 1 User'
#   user1= User.new(email: 'test@test.com' , password: '123456')
#   user1.save!

# puts 'User created'
