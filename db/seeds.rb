require 'faker'

# Crear 10 usuarios con solo nombre y email
10.times do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email
  )
end

# Crear 2 performances
performance1 = Performance.create!(
  title: "Concert of #{Faker::Music.band}",
  date: Faker::Date.forward(days: 30)
)

performance2 = Performance.create!(
  title: "Play of #{Faker::Book.title}",
  date: Faker::Date.forward(days: 60)
)

# Crear 6 tickets para cada performance
6.times do
  Ticket.create!(
    status: 'available',
    performance: performance1,
    price: Faker::Number.between(from: 10, to: 100)
  )
end

6.times do
  Ticket.create!(
    status: 'available',
    performance: performance2,
    price: Faker::Number.between(from: 10, to: 100)
  )
end

# Crear 2 transacciones, una por cada performance con un ticket comprado
ticket1 = Ticket.where(performance: performance1).first
ticket2 = Ticket.where(performance: performance2).first

user1= User.order('RANDOM()').first
user2= User.order('RANDOM()').first

Transaction.create!(
  user: user1, # Asignar a un usuario aleatorio
  ticket: ticket1,
  transaction_type: 'purchase', # Tipo de transacción: compra
  amount: ticket1.price
)
ticket1.update!(status: 'reserved', user: user1) # Actualizar el estado del ticket a 'reserved'

Transaction.create!(
  user: user2, # Asignar a otro usuario aleatorio
  ticket: ticket2,
  transaction_type: 'purchase', # Tipo de transacción: compra
  amount: ticket2.price
)
ticket2.update!(status: 'reserved', user: user2) # Actualizar el estado del ticket a 'reserved'

puts 'Se han creado 10 usuarios, 2 performances, 12 tickets y 2 transacciones.'
