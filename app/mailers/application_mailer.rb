# typed: strict
# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  extend T::Sig

  default from: 'Ninetyfour <support@ninetyfour.io>'
  layout 'mailer'
end
