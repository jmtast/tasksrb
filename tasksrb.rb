# cat hello_world.rb
require "cuba"
require "mote"
require "ohm"
require "cuba/render"
require_relative "./models/task"


Cuba.use Rack::Session::Cookie,
  secret: "__a_very_long_string__"

Cuba.use Rack::Static,
  root: "public",
  urls: ["/js", "/css", "/img"]

Cuba.plugin Mote::Helpers
Cuba.plugin Cuba::Render

Ohm.connect

Cuba.define do
  on root do

    ## This block defines what the application does on a GET request.
    ## First it checks if the database has been initialized. If not, it does
    ## that.
    ## If it's initialized, it retrieves the task list information from it and
    ## uses the template engine to render the list and the task creator for
    ## that list.

    on get do
      if TaskList.all.ids.empty?
        res.redirect "seed"
      else
        task_list = TaskList.all.first.tasks
        parsed = Mote.parse(File.read("views/home.mote"), self, [:task_list])
        res.write parsed.call( task_list: task_list)
      end
    end

    ## This block defines what the application does on a POST request.
    ## It asumes that you come from the rendered page of the get request, so
    ## the task_list has been created.
    ## It retrieves the information from the form and creates a new task with
    ## it. After that, the task is saved and added to the list, and the list is
    ## also saved to the database. Finally, it redirects to the home page.

    on post do
      task_list = TaskList.all.first
      on param("task") do |task|
        new_task = Task.create(description: task, is_done: 0)
        new_task.save
        task_list.tasks.push(new_task)
        task_list.save
        res.redirect "/"
      end

    end
  end

  on post, "tasks/do/:id" do |id|
    task = Task[id]
    task.do_it
    task.save
    res.redirect "/"
  end

  on post, "tasks/undo/:id" do |id|
    task = Task[id]
    task.undo_it
    task.save
    res.redirect "/"
  end

  on delete, "tasks/:id" do |id|
    task_list = TaskList.all.first
    task_list.tasks.delete(Task[id])
    task_list.save
    res.redirect "/"
  end

  ## This block is the seed of the database. You can't use the app without a
  ## task list, so if at the home page, the database doesn't have a list, it
  ## redirects to the seed page that creates it, which then redirects again
  ## to the home page to render the app.

  on "seed" do
    task_list = TaskList.create
    task_list.save

    res.redirect "/"
  end



### FOR DEBUGGING PURPOSES ###

  on "cleandb" do     # cleans the database and creates the list
    Ohm.flush

    res.redirect "seed"
  end

  on "flush" do       # cleans the database
    Ohm.flush

    res.write "Database flushed!"
  end

  on "nada" do        # empty webpage to go back and forth from the app
    res.write "Nada!"
  end
end
