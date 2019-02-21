class Movie < ActiveRecord::Base
    def self.mpaa_ratings
        ['G', 'PG', 'PG-13', 'R']
    end
end
