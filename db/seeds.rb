# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

paste_magazine, publishers_weekly, greywolf_press, mcsweeneys =
    ["Paste Magazine", "Publishers Weekly", "Graywolf Press", "McSweeney's"]
        .map { |name| PublisherRepository[name] }
        .each { |publisher| PublisherRepository << publisher }

joel, hannah, marguerite, kingsley, fannie, camille, rainer =
    ["Joel Hartse", "Hannah P. Templer", "Marguerite Z. Duras", "Kingsley Amis", "Fannie Peters Flagg", "Camille Byron Paglia", "Rainer Steel Rilke"]
        .map { |name| Author.with_full_name(name).first_or_create! }

books = Book.create! [
  { title: "American Elf", authors: [joel, hannah, marguerite],
    isbn13: "978-1-891830-85-3", isbn10: "1-891-83085-6", publication_year: 2004, publisher: paste_magazine, edition: "Book 2", list_price: 1000 },
  { title: "Cosmoknights", authors: [kingsley],
    isbn13: "978-1-60309-454-2", isbn10: "1-603-09454-7", publication_year: 2019, publisher: publishers_weekly, edition: "Book 1", list_price: 2000 },
  { title: "Essex County", authors: [kingsley],
    isbn13: "978-1-60309-038-4", isbn10: "1-603-09038-X", publication_year: 1990, publisher: greywolf_press, edition: nil, list_price: 500 },
  { title: "Hey, Mister (Vol 1)", authors: [hannah, fannie, camille],
    isbn13: "978-1-891830-02-0", isbn10: "1-891-83002-3", publication_year: 2000, publisher: greywolf_press, edition: "After School Special", list_price: 1200 },
  { title: "The Underwater Welder", authors: [rainer],
    isbn13: "978-1-60309-398-9", isbn10: "1-603-09398-2", publication_year: 2022, publisher: mcsweeneys, edition: nil, list_price: 3000 }  
  ].map { |but| but.without(:isbn10, :edition) }