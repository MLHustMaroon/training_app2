class User < ApplicationRecord
  include AASM

  aasm do
    state :sleeping, initial: true
    state :running, :cleaning

    event :run do
      transitions from: :sleeping, to: :running
    end

    event :clean do
      transitions from: :running, to: :cleaning
    end

    event :sleep do
      transitions from: %i[running cleaning], to: :sleeping
    end
  end

  #attribute accessors
  attr_accessor :remember_token

  #callback functions
  before_save { self.email = self.email.downcase }

  #validates
  validates :name, presence: true, length: { minimum: 4, maximum: 255 }
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, format: { with: EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  #associations
  has_many :tasks, dependent: :destroy
  has_one :profile
  accepts_nested_attributes_for :profile

  #third-party functions
  has_secure_password

  #constants
  COMMON_ROLE = 0
  ADMIN_ROLE = 1

  #scope
  scope :common_users, -> { where(role: self::COMMON_ROLE) }

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def admin?
    self.role == User::ADMIN_ROLE
  end
end
