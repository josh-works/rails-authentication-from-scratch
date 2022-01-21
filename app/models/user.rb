class User < ApplicationRecord
  CONFIRMATION_TOKEN_EXPIRATION = 10.minutes
  has_secure_password
  
  before_save :downcase_email
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true, uniqueness: true
  
  def confirm!
    update_columns(confirmed_at: DateTime.current)
  end
  
  def confirmed?
    confirmed_at.present?
  end
  
  def generate_confirmation_token
    signed_id expires_in: CONFIRMATION_TOKEN_EXPIRATION, purpose: :confirm_email
    # https://github.com/rails/rails/blob/914caca2d31bd753f47f9168f2a375921d9e91cc/activerecord/lib/active_record/signed_id.rb
  end
  
  def unconfirmed?
    !confirmed?
  end
  
  private 
  
  def downcase_email
    self.email = email.downcase
  end
end
