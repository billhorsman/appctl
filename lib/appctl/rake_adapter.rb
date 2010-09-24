module Appctl
  
  class RakeAdapter
    
    def do_command(cmd)
      output = `rake #{cmd}`
      raise RakeError, "Problem calling #{cmd}" if $? != 0
      output
    end

    def db_migrate
      puts "Checking for migrations"
      do_command 'db:migrate'
    end
    
    def db_drop
      puts "Dropping database"
      do_command 'db:drop'
    end
    
    def db_create
      puts "Creating database"
      do_command 'db:create'
    end
    
  end
  
  class RakeError < RuntimeError
  end

end
