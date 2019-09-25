class KnownTasks
  def initialize(known_task_file_name)
   @tasks = Array.new
   IO.read(known_task_file_name).each_line do | line |
      @tasks.push(line.delete("\n"))
   end
  end
  def known?(task_name)
    @tasks.include?(task_name)
  end
  def print(config)
    @tasks.each do | line |
      config.putsq line
    end
  end
end

class LogEntry
  include Comparable
  def <=>(other)
    @commit_id <=> other.commit_id
  end

  def initialize(config, entry_string, known_tasks)
    entry_array = entry_string.split
    @commit_id = entry_array[0]
    
    # WARNING EXTREMELY MESSY AND BAD CODE
    # Doing this the long way 
    # Need to update this block with every commit...
    # Try and come back to fix this later
    if(entry_string.include?('time') || entry_string.include?('Jameel') || entry_string.include?('Completed') || entry_string.include?('1e6fbac4a3e3a612aa0fba4754460c9b811c905a') || entry_string.include?('970a95d05d2f9050679d47c28eff48d0f1c2d7fc') || entry_string.include?('2a0dda2b8fa0b348fbd44461b913d8f501c96992') || entry_string.include?('43abfd96e39c6395c5d3823c05536073ec2b983b') || entry_string.include?('238df079e94e7f858197202ff0a4f287a7b8fb5e') || entry_string.include?('78c083652fdf69e9f9f3aeb4938805c92a3017e8') || entry_string.include?('4586805e7fe113b82cb8418173fba09f8fa67890') || entry_string.include?('Thu Jan 26 23:12:00') || entry_string.include?('Thu Jan 19 12:01:20') || entry_string.include?('Thu Jan 19 10:25:56') || entry_string.include?('Wed Jan 18 21:51:14') || entry_string.include?('Wed Jan 18 21:03:32') || entry_string.include?('Wed Jan 18 20:21:01') || entry_string.include?('Wed Jan 18 19:20:40'))
        
        puts "\n"
        config.putsq entry_string
        puts "\n"
    end
  end
end

class GitLog
  def initialize(config, git_log_source, known_tasks = nil)
    if git_log_source.class == Array then
      @git_log = git_log_source
      return
    end
    @git_log = Array.new
    git_log_source.each_line do | line |
        @git_log.push(LogEntry.new(config, line, known_tasks))
    end
  end
  def include?(entry)
    @git_log.include?(entry)
  end
end

class NewLog
  def initialize(config, known_tasks)
    if config.git_from_file then
      stdout = IO.read("windowsCurrentLog")
    else
      stdout = `git log`
    end
    @git_log = GitLog.new(config, stdout, known_tasks)
  end
  def print(config)
    @git_log.print(config)
  end
end

class Summary
  attr_accessor :date, :report_type, :quiet, :error_out, :git_from_file
  def initialize(arg_list)
    @error_out = STDERR
  end
  def putsq(message)
    puts message unless @quiet
  end
  def puterr(message)
    @error_out.puts message
  end
end

config = Summary.new(ARGV)
known_tasks = KnownTasks.new("knowntasks")
git_log = NewLog.new(config, known_tasks)

