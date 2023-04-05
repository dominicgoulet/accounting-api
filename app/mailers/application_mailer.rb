# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Ninetyfour <support@ninetyfour.io>'
  layout 'mailer'
end
