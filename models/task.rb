class Task < Ohm::Model
  attribute :description
  attribute :is_done

  def set_description (description)
    task.set "description", description
  end

  def do_it
    self.is_done = 1
  end

  def undo_it
    self.is_done = 0
  end

  def done?
    is_done == "1"
  end
end

class TaskList < Ohm::Model
  list :tasks, Task
end