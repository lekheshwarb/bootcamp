require "active_record"

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    puts where("due_date < ?", Date.today).to_displayable_list
    puts "\n\n"

    puts "Due Today\n"
    puts where("due_date = ?", Date.today).to_displayable_list
    puts "\n\n"

    puts "Due Later\n"
    puts where("due_date > ?", Date.today).to_displayable_list
    puts "\n\n"
  end

  def self.add_task(task)
    create!(todo_text: task[:todo_text], due_date: Date.today + task[:due_in_days], completed: false)
  end

  def self.mark_as_complete!(id)
    todo_task = find(id)
    todo_task.completed = true
    todo_task.save
    todo_task
  end
end
