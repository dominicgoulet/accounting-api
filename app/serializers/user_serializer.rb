# frozen_string_literal: true

class UserSerializer
  include Alba::Resource

  root_key :user

  attributes :id,
             :email,
             :current_sign_in_at,
             :last_sign_in_at,
             :current_sign_in_ip,
             :last_sign_in_ip,
             :sign_in_count,
             :confirmation_token,
             :confirmed_at,
             :confirmation_sent_at,
             :unconfirmed_email,
             :reset_password_token,
             :reset_password_sent_at,
             :first_name,
             :last_name,
             :setup_completed_at
end
