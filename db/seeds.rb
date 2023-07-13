# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts 'Creating users...'
300.times do
  infected = FFaker::Boolean.random
  warning_count = rand(0..2)
  warning_count = rand(3.. 25) if infected

  user = User.create(
    name: FFaker::NameBR.name,
    birthday: FFaker::Time.date,
    gender: FFaker::Gender.binary,
    infected: infected,
    warning_count: warning_count,
    last_latitude: rand(0.0..89.999),
    last_longitude: rand(0.0..179.99)
  )

  Inventory.items.keys.each do |item|
    Inventory.create(
      user: user,
      item: item,
      quantity: rand(0..32)
    )
  end
end
puts 'Creating users...[OK]'
