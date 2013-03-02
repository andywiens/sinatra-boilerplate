class User
  include DataMapper::Resource
 
  property :id,              Serial
  property :fname,           String
  property :lname,           String
  property :email,           String
  property :password,        BCryptHash
 
  timestamps :at
 
  attr_accessor :password_confirmation
 
  validates_presence_of     :fname
  validates_presence_of     :lname
  validates_presence_of     :email
  validates_uniqueness_of   :email
  validates_confirmation_of :password
 
  validates_with_method :password_non_blank
 
  # Public class method than returns a user object if the caller supplies 
  # the correct email and password
  #
  def self.authenticate(email, password)
    user = first(:email => email)
    if user
      if user.password != password
        user = nil
      end
    end
    user
  end
 
  private
  # Private class method to verify password is non-blank
  # 
  def password_non_blank
    if password_confirmation.nil? || password_confirmation.empty?
      [ false, 'Missing password']
    else
      true
    end
  end
 
end
