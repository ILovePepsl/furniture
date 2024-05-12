namespace :scrape do
  desc 'Fetch furniture items from the web and store them in the database'
  task fetch_furniture: :environment do
    require 'nokogiri'
    require 'open-uri'

    url = 'https://www.enchantedlearning.com/wordlist/furniture.shtml'
    html = URI.open(url).read
    doc = Nokogiri::HTML(html)

    furniture_items = doc.css('.wordlist-item').map(&:text)

    furniture_items.each do |item_name|
      Product.create(name: item_name, price: rand(50..500),
                     description: "Beautiful and comfortable #{item_name.downcase}", image: 'default.jpg')
    end

    puts 'Furniture items have been successfully fetched and stored.'
  end
end
