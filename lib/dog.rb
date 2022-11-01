class Dog
    # describe ".create_table" do
    #     it 'creates the dogs table in the database' do
    #       DB[:conn].execute("DROP TABLE IF EXISTS dogs")
    #       Dog.create_table
    #       table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='dogs';"
    #       expect(DB[:conn].execute(table_check_sql)[0]).to eq(['dogs'])
    #     end
    #   end
    attr_accessor :name, :breed, :id

    def initialize(name:, breed:, id: nil)
        @id = id
        @name = name
        @breed = breed
    end
    def self.drop_table
        DB[:conn].execute("DROP TABLE IF EXISTS dogs")
    end
    def self.create_table
        sql =  <<-SQL
          CREATE TABLE IF NOT EXISTS dogs (
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
          )
          SQL
        DB[:conn].execute(sql)
      end
      
      def save
        sql = <<-SQL
          INSERT INTO dogs (name, breed)
          VALUES (?, ?)
        SQL
    
        DB[:conn].execute(sql, self.name, self.breed)
        self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    
        self
      end
      def self.create(name:, breed:)
        dog = Dog.new(name: name, breed: breed)
        dog.save
      end
      def self.new_from_db(row)
      
        self.new(id: row[0], name: row[1], breed: row[2])
      end
    #   def self.new_from_db(row)
    #     # self.new is equivalent to Song.new
    #     self.new(id: row[0], name: row[1], album: row[2])
    #   end
      def self.all
        sql = <<-SQL
          SELECT *
          FROM dogs
        SQL
    
        DB[:conn].execute(sql).map do |row|
          self.new_from_db(row)
        end
      end
      def self.find_by_name(name)
        sql = <<-SQL
          SELECT *
          FROM dogs
           WHERE name = ?
          
        SQL
    
        DB[:conn].execute(sql, name).map do |row|
          self.new_from_db(row)
        end.first
    end
        def self.find(id)
            sql = <<-SQL
                SELECT *
                FROM dogs
                WHERE id = ?
            SQL
    
            DB[:conn].execute(sql, id).map do |row|
                self.new_from_db(row)
            end.first
        end
      end
    


    
    

