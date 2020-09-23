# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

products = Product.create([{ product_code: '001', name: 'Lavender heart', price: '9.25' }, 
	                       { product_code: '002', name: 'Personalised cufflinks', price: '45.00' },
	                       { product_code: '003', name: 'Kids T-shirt', price: '19.95' }
	                      ])
