#interacts and gets info/data from user
#require 'colorized_string'
class Interface 
    attr_accessor :prompt, :user
    
    def initialize
        @prompt = TTY::Prompt.new
    end

    def welcome
        puts " "
        
        puts "
✨                                                                                          ✨
                ██     ██ ███████ ██       ██████  ██████  ███    ███ ███████                 
                ██     ██ ██      ██      ██      ██    ██ ████  ████ ██                      
                ██  █  ██ █████   ██      ██      ██    ██ ██ ████ ██ █████                   
                ██ ███ ██ ██      ██      ██      ██    ██ ██  ██  ██ ██                      
                 ███ ███  ███████ ███████  ██████  ██████  ██      ██ ███████                 
✨                                                                                          ✨".colorize(:color => :yellow, :background => :light_white)
         books_image
    end

    def choose_login_or_register
        puts " "
        prompt.select("Log in or register?") do |menu|
            menu.choice "Log In".colorize(:color => :cyan, :background => :default), -> { User.logging_someone_in(self) }
            menu.choice "Register".colorize(:color => :cyan, :background => :default), -> { User.create_new_user(self) }
            menu.choice "Logout".colorize(:color => :cyan, :background => :default), -> {self.logout}
        end
    end

    def main_menu
        system("clear")
        books_image
        puts " "
        puts "                              ✨ Welcome to Book Club #{user.name}! ✨"
        puts " "
        answer = prompt.select("What would you like to do?") do |menu|
            menu.choice "Search for reviews".colorize(:color => :light_blue, :background => :default), -> { Review.search_for_reviews(self) }
            menu.choice "Review a book".colorize(:color => :light_blue, :background => :default), -> { user.make_review(self)}
            menu.choice "View my reviews".colorize(:color => :light_blue, :background => :default), -> {user.my_reviews(self)}
            menu.choice "Log out".colorize(:color => :light_blue, :background => :default), -> { self.logout }
            #pass in (self)
        end
    end

    def logout
        system("clear")
        puts " "
        puts "
          📚  ┌─┐┌─┐┌┬┐┌─┐  ┌┐ ┌─┐┌─┐┬┌─  ┌─┐┌─┐┌─┐┌┐┌   📚         
          📖  │  │ ││││├┤   ├┴┐├─┤│  ├┴┐  └─┐│ ││ ││││   📖         
          📚  └─┘└─┘┴ ┴└─┘  └─┘┴ ┴└─┘┴ ┴  └─┘└─┘└─┘┘└┘   📚         ".colorize(:color => :yellow, :background => :light_white)
        
                                                  
        puts " "                                        
        puts "                                                                                                           
                    ,..........   ..........,
                ,..,'          '.'          ',..,
               ,' ,'            :            ', ',
              ,' ,'             :             ', ',
             ,' ,'              :              ', ',
            ,' ,'............., : ,.............', ',
           ,'  '............   '.'   ............'  ',
            '''''''''''''''''';''';''''''''''''''''''                               
                                                 ".colorize(:color => :light_green, :background => :default)
        return exit
    end

    def books_image
        puts "                                                         
                           .--.           .---.        .-.
                       .---|--|   .-.     | B |  .---. |~|    .--.
                    .--|===|We|---|_|--.__| O |--|:::| |~|-==-|==|---.
                    |%%|HI!|lc|===| |~~|To| O |--|   |_|~|CLUB|BY|___|-.📚
                    |  |   |om|===| |==|  | K |  |:::|=| |    |::|---|=|📚
                    |  |   |e~|   |_|__|  |   |__|   | | |    |RK|___| |📚
                    |~~|===|--|===|~|~~|%%|~~~|--|:::|=|~|----|==|---|=|📚
                  🐛^--^---'--^---^-^--^--^---'--^---^-^-^-==-^--^---^-'📚"
    end
end    