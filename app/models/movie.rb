class Movie < ActiveRecord::Base
    
    def sort_by_title
        #change = ['cents', 'pennies', 'coins', 'dimes', 'pence', 'quarters']
        movie.sort_by { |title| title }
    end

    def sort_by_date
        
    end
end
