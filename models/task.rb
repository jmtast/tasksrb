class Task
  attr_accessor :description, :is_done

  def initialize(description)
    @description = description
    @is_done = false
  end

  def do_it
  	@is_done = true
  end

  def undo_it
    @is_done = false
  end
end

class TaskList
  attr_accessor :tasks

  def initialize
    @tasks = Array.new
  end

	def add(task)
    @tasks.push(task)
	end

	def do_it
		self.do_it
	end

  def undo_it
    self.undo_it
  end

  def each(&block)
    @tasks.each(&block)
  end

end