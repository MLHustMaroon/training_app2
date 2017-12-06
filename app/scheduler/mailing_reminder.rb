require 'sidekiq-scheduler'
class MailingReminder
  include Sidekiq::Worker
  def perform
    mailer = SesMailer.new
    Task.each do |task|
      next unless ((task.deadline - Time.now) / 1.day).round <= 2
      mailer.send_mail(task.user.email,
                       'task reminder',
                       render('mails/task_reminder', task: task))
    end
  end
end