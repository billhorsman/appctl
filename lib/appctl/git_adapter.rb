module Appctl
  
  class GitAdapter
    
    def do_command(cmd)
      output = `git #{cmd}`
      raise GitError, "Problem calling #{cmd}" if $? != 0
      output
    end

    def branch_list
      puts "Fetching latest from remote"
      do_command 'fetch'
      hash = {}
      active_branch = nil
      do_command('branch -r').split("\n").map{|line| 
        name = line.strip.sub(/^origin\//, '')
        if name =~ /^HEAD/
          # ignore
        else
          hash[name] ||= {:name => name}
          hash[name][:remote] = true
        end
      }
      do_command('branch -l').split("\n").map{|line| 
        name = line.sub(/^\*/, '').strip
        hash[name] ||= {:name => name}
        hash[name][:local] = true
        hash[name][:active] = line =~ /\*/
      }
      hash.values.sort_by{|h| h[:name]}
    end
    
    def checkout(name)
      branch = branch_list.detect{|h| h[:name] == name}
      raise ArgumentError, "Unknown branch #{name}" if branch.nil?
      if branch[:local]
        do_command "checkout #{name}"
      else
        puts "Fetching #{name} from remote"
        do_command "checkout --track -b #{name} origin/#{name}"
      end
    end
    
    def pull
      puts "Pulling from remote"
      do_command "pull"
    end
    
  end
  
  class GitError < RuntimeError
  end
  
end