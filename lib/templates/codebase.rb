CommitHookr.call do
  
  # Your codebase project slug
  CODEBASE_PROJECT = "my_awesome_project"
   
  def choose_ticket_number
    case @ticket_number = ui.ask("Codebase ticket number ([number], [n] none, [l] list): ") { |q| q.validate = // }.strip #TODO validatestrip .input
    when "n"
      commit!
    when "l"
      list_tickets
      choose_ticket_number
    else
      self.message << " [touch:#{@ticket_number}]" if @ticket_number && @ticket_number != ""
    end
  end
  
  def list_tickets
    user = `git config codebase.username`.strip
    api_key = `git config codebase.apikey`.strip
    domain = `git config codebase.domain`.strip
    
    tickets = Tickets.new(:user => user, :api_key => api_key, :domain => domain, :project => CODEBASE_PROJECT).all["tickets"]
    puts "---"
    tickets.each do |ticket|
      puts "#{ticket["ticket_id"]}: #{ticket["summary"]}"
    end
    puts ""
  end
  
  def enter_time
    @time = ui.ask("Time spent (in minutes): ")
    self.message << " {t:#{@time}}" if @time && @time != ""
  end
  
  self.message = "#{original_message.strip}\n" 
  choose_ticket_number unless self.message.match(/\[touch:.+\]/)
  enter_time unless self.message.match(/\{t:.+\}/)
  
  write self.message
end

require "httparty"

class Tickets
  include HTTParty
  headers 'Accept' => 'application/xml'
  headers 'Content-type' => 'application/xml'
  format :xml
  
  def initialize(args)
    @auth = {:username => args.delete(:user), :password => args.delete(:api_key)}
    @host = args.delete(:domain)
    @project = args.delete(:project)
  end
  
  def all(query="")
    self.class.get("http://#{@host}/#{@project}/tickets", :basic_auth => @auth, :query => {:query => query})
  end
end