class Profile < ApplicationRecord
  belongs_to :user
  GENDER_HASH = { male: 1, female: 2, other: 3 }.freeze
  mount_uploader :avatar, AvatarUploader
end
