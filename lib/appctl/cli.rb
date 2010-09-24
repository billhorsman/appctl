require 'fileutils'

module Appctl
  
  class Cli

    attr_accessor :argv

    def initialize(argv)
      @argv = argv
      @control = Appctl::Control.new
    end

    def run
      method = (argv.shift || 'help').to_sym
      name = argv.shift
      if [:update, :use, :list, :version].include? method
        begin
          if name
            send(method, name)
          else
            send(method)
          end
        rescue ArgumentError => exc
          puts exc.message
        rescue GitError => exc
          puts "Git: #{exc.message}"
        end
      else
        help
      end
    end
    
    def list
      puts @control.list.join("\n")
    end
    
    def use(name)
      @control.use(name)
    end
    
    def update
      @control.update
    end
    
    def version
      puts Appctl::VERSION
    end

    def help
      puts <<EOHELP
  Usage: appctl command 
  
  Commands:
  update
  use
  list
  version

  Add '-h' to any command to see their usage
EOHELP
    end

  end

end
