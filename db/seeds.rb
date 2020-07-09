User.destroy_all
Review.destroy_all
Book.destroy_all

5.times do
    Book.create(
        title: Faker::Book.title,
        author: Faker::Book.author,
        genre: Faker::Book.genre
    )
end

5.times do
    User.create(
        name: Faker::Name.name,
        age: rand(18..100),
        display_name: Faker::Superhero.unique.name
    )
end

Review.create(
    comment: Faker::Books::Lovecraft.paragraph,
    rating: rand(0..10),
    recommend: "Yes",
    user_id: 1,
    book_id: 1
)

Review.create(
    comment: Faker::Books::Lovecraft.paragraph,
    rating: rand(0..10),
    recommend: "No",
    user_id: 2,
    book_id: 2
)

Review.create(
    comment: Faker::Books::Lovecraft.paragraph,
    rating: rand(0..10),
    recommend: "Yes",
    user_id: 3,
    book_id: 3
)

Review.create(
    comment: Faker::Books::Lovecraft.paragraph,
    rating: rand(0..10),
    recommend: "Yes",
    user_id: 4,
    book_id: 4
)

Review.create(
    comment: Faker::Books::Lovecraft.paragraph,
    rating: rand(0..10),
    recommend: "No",
    user_id: 5,
    book_id: 5
)

puts "Done seeding!"