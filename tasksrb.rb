# cat hello_world.rb
require "cuba"
require "mote"
require "cuba/render"
require_relative "./models/task"

Cuba.use Rack::Session::Cookie,
  secret: "__a_very_long_string__"

Cuba.plugin Mote::Helpers
Cuba.plugin Cuba::Render

Cuba.define do
  task_list = TaskList.new
  task1 = Task.new("This is my first task")
  task2 = Task.new("This is my second task")

  task_list.add(task1)
  task_list.add(task2)

  on root do
    on get do
      parsed = Mote.parse(File.read("views/home.mote"), self, [:task_list])
      res.write parsed.call( task_list: task_list)
    end

  	on post do
      on param("task") do |task|
    		new_task = Task.new(task)
        task_list.add(new_task)
        res.redirect "/"
      end
  	end
  end
end
