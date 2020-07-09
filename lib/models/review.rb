class Review < ActiveRecord::Base
    belongs_to :user
    belongs_to :book

    def self.search_for_reviews(interface_instance)
        system "clear"
        prompt = TTY::Prompt.new
        puts " "
        interface_instance.books_image
        puts " "
        answer = prompt.ask("Enter the book title:")
        book_instance = Book.all.find_by(title: answer)
        if book_instance
            self.get_book_reviews(book_instance, interface_instance)
        else 
            puts "\nThat book has not been reviewed 🙁".colorize(:color => :cyan, :background => :default)
            

            spinner = TTY::Spinner.new("[:spinner] Back to main menu ...".colorize(:color => :light_blue, :background => :light_white), format: :pulse_2)
            spinner.auto_spin # Automatic animation with default interval
            sleep(3) # Perform task
            spinner.stop('Done!'.colorize(:color => :light_blue, :background => :light_white)) # Stop animation
            interface_instance.main_menu
        end 
    end

    def self.get_book_reviews(book_instance, interface_instance)
        book_id = book_instance.id
        prompt = TTY::Prompt.new
        #loading animation
        spinner = TTY::Spinner.new("[:spinner] Getting reviews ...".colorize(:color => :green, :background => :light_white), format: :pulse_2)
        spinner.auto_spin # Automatic animation with default interval
        sleep(2) # Perform task
        spinner.stop('Done!'.colorize(:color => :green, :background => :light_white)) # Stop animation
       
        puts " "
        puts "These are the reviews for:"
        puts "Title: \"#{book_instance.title}\"".colorize(:color => :default, :background => :light_black )
        puts "By: #{book_instance.author}".colorize(:color => :default, :background => :light_black )
        puts " " 
        reviews_array = Review.all.select {|rev| rev.book_id == book_id }
        values_to_print = reviews_array.map { |rev| 
                    [rev.user.name, rev.comment, rev.rating]
                    }
        self.reviews_table(values_to_print)
        puts " "
        response = prompt.select("Would you like to search for another book or go back to main menu??", %w(Search Menu))
        if response == "Menu"
            interface_instance.main_menu
        else
            self.search_for_reviews(interface_instance)
        end
    end 
   
    def self.reviews_table(array_to_print)
        reviews_table = TTY::Table.new ['User Name','Comment','Rating'], array_to_print
        puts reviews_table.render(:unicode, alignments: [:center, :center], padding: [0,1,0,1] )
    end 

end