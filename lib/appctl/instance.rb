module Appctl
  
  class Instance
    
    def initialize(params)
      @name = params[:name]
      @active = params[:active]
      @db = params[:db]
      @local = params[:local]
      @remote = params[:remote]
    end
    
    def to_s
      a = []
      if @active
        a << '*'
      elsif @local && @db
        a << '-'
      else
        a << ' '
      end
      a << @name
      a << "(local-only)" if @local && !@remote
      a.join(' ')
    end
    
  end
  
end