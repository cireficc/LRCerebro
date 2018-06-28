class CreateAsanaTasksJob < ApplicationJob
  queue_as :default

  # perform(*args) expects the first argument passed to be the object for task scheduling,
  # and the second argument to be the method name to be called in Asana. So, to create a
  # Work task in Asana, the Work object should be passed as the first parameter, and
  # the method name 'create_work_task' should be the second.
  def perform(*args)

    puts "AsanaTasksJob args: #{args.inspect}"

    object = args.first
    method = args.second

    AsanaHelper.send(method, object)
  end
end
