require 'yaml'

module Appctl
  
  class Control
    
    def initialize
      @git_adapter = Appctl::GitAdapter.new
      @db_adapter = Appctl::DbAdapter.new
      @rake_adapter = Appctl::RakeAdapter.new
    end
    
    def list
      branch_list = @git_adapter.branch_list
      db_list = @db_adapter.list
      branch_list.map {|b|
        b[:db] = db_list.include?(b[:name])
        Instance.new(b)
      }
    end
    
    def update
      @git_adapter.pull
      @rake_adapter.db_migrate
    end
    
    def reset
      @rake_adapter.db_drop
      @rake_adapter.db_create
      @db_adapter.import name
      @rake_adapter.db_migrate
      @rake_adapter.db_test_clone_structure
      `mkdir -p tmp; touch tmp/restart.txt`
    end
    
    def use(name)
      @db_adapter.update_database_yaml name
      @git_adapter.checkout name
      db_list = @db_adapter.list
      if !db_list.include?(name)
        @rake_adapter.db_create
        @db_adapter.import name
      else
        puts "Using existing database"
      end
      @rake_adapter.db_migrate
      @rake_adapter.db_test_clone_structure
      `mkdir -p tmp; touch tmp/restart.txt`
    end

  end
  
end