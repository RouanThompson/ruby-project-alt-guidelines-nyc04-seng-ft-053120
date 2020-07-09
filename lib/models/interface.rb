#interacts and gets info/data from user
#require 'colorized_string'
class Interface 
    attr_accessor :prompt, :user
    
    def initialize
        @prompt = TTY::Prompt.new
    end

    def welcome
        puts "

       .--.           .---.        .-.
   .---|--|   .-.     | B |  .---. |~|    .--.
.--|===|We|---|_|--.__| O |--|:::| |~|-==-|==|---.
|%%|HI!|lc|===| |~~|To| O |--|   |_|~|CLUB|BY|___|-.📚
|  |   |om|===| |==|  | K |  |:::|=| |    |::|---|=|📚
|  |   |e~|   |_|__|  |   |__|   | | |    |RK|___| |📚
|~~|===|--|===|~|~~|%%|~~~|--|:::|=|~|----|==|---|=|📚
^--^---'--^---^-^--^--^---'--^---^-^-^-==-^--^---^-'📚

"
    end

    def choose_login_or_register
        puts " "
        prompt.select("Log in or register?") do |menu|
            menu.choice "Log In".colorize(:color => :cyan, :background => :default), -> { User.logging_someone_in }
            menu.choice "Register".colorize(:color => :cyan, :background => :default), -> { User.create_new_user }
        end
    end
    #::cyan on :default
    #puts "This is light blue with red background".colorize(:color => :light_blue, :background => :red)
    def main_menu
        system("clear")
        puts "Welcome to Book Club #{user.name}!"
        puts " "
        answer = prompt.select("What would you like to do?") do |menu|
            menu.choice "Search for reviews".colorize(:color => :cyan, :background => :default), -> { Review.search_for_reviews(self) }
            menu.choice "Review a book".colorize(:color => :cyan, :background => :default), -> { user.make_review(self)}
            menu.choice "View my reviews".colorize(:color => :cyan, :background => :default), -> {user.my_reviews(self)}
            menu.choice "Log out".colorize(:color => :cyan, :background => :default), -> { self.logout }
            #pass in (self)
        end
    end

    # def back_to_menu
    #     user.my_reviews
    #     main_menu
    # end

    def logout
        system("clear")
        puts "Thanks for visiting us! Come back soon 📚"
        puts "
        .     `ss+.                                           
        yN+    /`                `--`                          
        :+do  -+oooo+:           ..:s:                         
          .dyyo////-./y/---`./++++/. :                         
           -m/:::::/:.:hs+shs+////:os:        -:`              
          `+h::::://::.+hyh/::::::-`-y+  .:+yyyN:              
        -++od/:::/oo/::hyN/:::///::--/msdhy+.``-               
       /++++sho/:sNNhoyhyN/+o+/:/:::-/Ny-`                     
       o+++ososyyyddhso++yhdMdo::::::hy//.                     
       -o+++oso+++++++++++sdmh+///+shs+//+`                    
        .+++++ooooo+++++++++ossyyyys++++/+-                    
 `.```````:++++++ohdysssooooooooossoo+++++`                    
 -yo-`......o++++++shhhhhhsoooo+++++++++:`                     
 -hhys:````.+++++++++++++++++++++o+++:.`                       
 -hhhhhs/`  `/++++++++++++++++++/--.                           
:oyhhhhhhy/` `/++++++++/::------......                         
y++shhhhhhhs` .++++/-..` ``....------//-`                      
ooo+shhhhhhhs:-.----.-/ossyyyhhhhhhhhhhy`                      
`/ysohhhhhhhdys+//+shhhhhhhhhhhhhhhhhhy.                       
 `dhhhhhhhhhdhhhhhhhdhhhhhhhhhhhhhhhhho`                       
  hhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhyysy+/:.``                  
  hhhhhhhhhhhosyyysyhhhhhhhhhhhhyo+++oy+++o++///////:::.`      
  yhhhhhhhhhh++++++yhhhhhhhhhhhhoooosso++++++++++++++++o+/.    
  shhhhhhhhhdyssssyhhhhhhhhhhhhhhhhys+++++++++++++++++++++o/   
  +yhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhsooooooo+oooooooooooooo+++  
   ./syhhhhhdhhhhhhhhhhhhhhhhhhhhhhooooooooooooooooooooooooos  
      -oyhhhdhhhhhdhhhhhhhhhhhhhyy+/osooooooooso/:-...--:+oo+  
        .+hhdhhhhhdhhhhhyhyso/:--.    ..---..`                 
          .odhhhhhhhys+:-`                                     
            /syyso:.                                           
                                                              
        ".colorize(:color => :green, :background => :default)
#:green on :default 
        #ColorizedString.color_samples
        return exit
    end
end    