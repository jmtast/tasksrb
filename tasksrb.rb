# cat hello_world.rb
require "cuba"
require "mote"
require "ohm"
require "cuba/render"
require_relative "./models/task"


Cuba.use Rack::Session::Cookie,
  secret: "__a_very_long_string__"

Cuba.plugin Mote::Helpers
Cuba.plugin Cuba::Render

Ohm.connect

Cuba.define do
  task_list = TaskList.create
  task1 = Task.create(description: "This is my first task", is_done: 0)
  task2 = Task.create(description: "This is my second task", is_done: 0)

  task1.save
  task2.save

  task_list.add(task1)
  task_list.add(task2)

  on root do
    on get do
      parsed = Mote.parse(File.read("views/home.mote"), self, [:task_list])
      res.write parsed.call( task_list: task_list)
    end

    on post do
      on param("task") do |task|
        new_task = Task.create(description: task, is_done: 0)
        new_task.save
        task_list.add(new_task)
        res.redirect "/"
      end
    end
  end
end
