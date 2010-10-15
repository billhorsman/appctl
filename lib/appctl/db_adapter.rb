module Appctl
  
  class DbAdapter
    
    def initialize
      hash = YAML.load_file('config/database.yml')
      @db_prefix = hash['appctl']['prefix']
      @dump = hash['appctl']['dump']
    end
    
    def list
      re = Regexp.new("^#{@db_prefix}")
      hash = dev_hash
      `echo "show databases;" | mysql -u #{hash['username']} --password=#{hash['password']}`.split("\n").select{|name| name =~ re}.map{|name| name.sub re, ''}
    end
    
    def update_database_yaml(db_name)
      hash = YAML.load_file('config/database.yml')
      hash['development']['database'] = "#{@db_prefix}#{db_name}"
      File.open( 'config/database.yml', 'w' ) do |out|
        YAML.dump( hash, out )
      end
    end
    
    def import(name)
      hash = dev_hash
      db_name = "#{@db_prefix}#{name}"
      puts "Importing snapshot from #{@dump}"
      `gunzip -c #{@dump} | mysql -u #{hash['username']} --password=#{hash['password']} #{db_name}`
    end
    
    def dev_hash
      YAML.load_file('config/database.yml')['development']
    end
    
  end
  
end