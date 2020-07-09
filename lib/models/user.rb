
class User < ActiveRecord::Base
    has_many :reviews
    has_many :books, through: :reviews

    def self.try_again(interface)
        prompt = TTY::Prompt.new
        puts " "
        if prompt.select("Would you like to try again?", %w(Yes No)) == "No"
            interface.choose_login_or_register
        end
    end

    def self.create_new_user(interface)
        prompt = TTY::Prompt.new
        puts "----------------------------\nLets get to know you better"
        input = prompt.collect do
            key(:name).ask("What is your name?:")
            key(:age).ask("How old are you?:")
            key(:display_name).ask("Create a cool display name:")
        end
        #loops until it does not find a match
        until !User.find_by(display_name: input[:display_name])
            puts "\nSorry #{input[:name]}, that display name has been taken".colorize(:color => :cyan, :background => :default)
            self.try_again(interface)
            input[:display_name] = prompt.ask("Create a display name:")
        end
        #creates user with their input
        User.create(name: input[:name], age: input[:age], display_name: input[:display_name])
    end  

    def self.logging_someone_in(interface)
        prompt = TTY::Prompt.new
        display_name = prompt.ask("Insert your display name:")
        #loading animation
        spinner = TTY::Spinner.new("[:spinner] Loading ...".colorize(:color => :light_blue, :background => :light_white), format: :pulse_2)
        spinner.auto_spin # Automatic animation with default interval
        sleep(2) # Perform task
        spinner.stop('Done!'.colorize(:color => :cyan, :background => :light_white)) # Stop animation
       
        if found_user = User.find_by(display_name: display_name)
            found_user
        else
            puts "\nDisplay name does not exist".colorize(:color => :cyan, :background => :default)
            interface.choose_login_or_register
        end
    end

    def make_review(interface)
        prompt = TTY::Prompt.new
        input = prompt.collect do
            puts "\nBook Review"
            key(:title).ask("Enter Title of book:".colorize(:color => :cyan, :background => :default))
            key(:author).ask("Enter the Author's name:".colorize(:color => :cyan, :background => :default))
            key(:genre).ask("What is the genre of the book:".colorize(:color => :cyan, :background => :default))
            key(:comment).ask("Go ahead review away:".colorize(:color => :cyan, :background => :default))
            key(:rating).ask("On a scale of 1 - 10 how would rate the book?".colorize(:color => :cyan, :background => :default))
            key(:recommend).select("Do you recommend this book?".colorize(:color => :cyan, :background => :default), %w(Yes No))
        end

        Review.create(
            user_id: self.id,
            book_id: check_if_book_exist(input),
            comment: input[:comment],
            rating: input[:rating],
            recommend: input[:recommend]
            )
        back_to_main(interface)
    end

    def check_if_book_exist(input)
        Book.all.each do |book|
            if ((input[:title] == book.title) && (input[:author] == book.author) && (input[:genre] == book.genre))
                return book.id
            end
        end
        return Book.create(
            title: input[:title],
            author: input[:author],
            genre: input[:genre]
            ).id
    end

    def delete_review(user_review, interface)
        user_review.destroy
        puts " "
        puts "Your review is lost to the ether...".colorize(:color => :light_yellow, :background => :red)
        my_reviews(interface)
    end   
    
    def edit(user_reviews, num, interface)
        prompt = TTY::Prompt.new
        choice = prompt.select("Choose a No. of the review you want to modify", num)
        user_reviews[choice -= 1] 

        edit_or_delete = prompt.select("Do want to Edit or Delete this review?", %w(Edit Delete))

        if edit_or_delete == "Delete"
            delete_review(user_reviews[choice], interface)
            my_reviews(interface)
        end

        attribute = prompt.select("What part of this review do you want to edit?", %w(comment rating recommend))

        if attribute == "recommend"
            answer = prompt.select("Do you recommend this book?", %w(Yes No))
            user_reviews[choice].update(recommend: answer)
        elsif attribute == "comment"
            answer = prompt.ask("Go ahead and change your comment:")
            user_reviews[choice].update(comment: answer)
        else
            answer = prompt.ask("Go ahead and change your rating:")
            user_reviews[choice].update(rating: answer)
        end
        my_reviews(interface)
    end

    def my_reviews(interface)
        prompt = TTY::Prompt.new

        #if we change to class methods, change self.id 
        user_reviews = User.find_by(id: self.id).reviews
        if user_reviews == []
            puts "You have no reviews, how sad 🙁".colorize(:color => :cyan, :background => :default)
            back_to_main(interface)
        end
        
        i = 0
        num = []
        array_to_print = []
        user_reviews.each do |review|
            num << i += 1
            array_to_print << ["#{i}", review.book.title, review.book.author, review.book.genre, review.comment, review.rating, review.recommend]
        end

        print_table(array_to_print)
        answer = prompt.select("What would you like to do?") do |menu|
            menu.choice "Edit".colorize(:color => :cyan, :background => :default), -> {edit(user_reviews, num, interface)}
            menu.choice "Main menu".colorize(:color => :cyan, :background => :default), -> {interface.main_menu}
        end
    end

    def print_table(array_to_print)
        prompt = TTY::Prompt.new
        reviews_table = TTY::Table.new ["No. ", "Title", "Author", "Genre", "Comment", "Rating", "Recommend"], [[],[]], array_to_print
        puts reviews_table.render(:unicode, alignments: [:center, :center], padding: [0,1,0,1])
    end

    def back_to_main(interface)
        prompt = TTY::Prompt.new
        response = prompt.select("Would you like to make a review or go back to main menue?", %w(Review Menu))
        if response == "Menu"
            return interface.main_menu
        else
            return make_review(interface)
        end
    end
end
