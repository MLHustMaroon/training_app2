class SesMailer
  include ApplicationHelper
  require 'aws-sdk-ses'
  def initialize
    Aws.config.update({ credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']) })
    @sender = settings['aws']['ses']['sender']
    @ses = Aws::SES::Client.new(region: settings['aws']['region'])
    @encoding = 'UTF-8'
  end
  def send_mail recipient, subject, body
    resp = @ses.send_email({
              destination: {
                  to_addresses: [
                      recipient
                  ]
              },
              message: {
                  body: {
                      text: {
                          charset: @encoding,
                          data: body
                      }
                  },
                  subject: {
                      charset: @encoding,
                      data: subject
                  },
              },
              source: @sender
                          })
  end
end