module Rake
  class Task
    # We want to use the original execute method later
    alias original_execute execute

    def execute(args = nil)
      original_execute(args)
    rescue Exception => ex
      notice = Dogcatcher.build_notice(ex)
      notice.notifier = 'rake'
      notice.action = name
      Dogcatcher.notify(notice)
      raise ex
    end
  end
end
