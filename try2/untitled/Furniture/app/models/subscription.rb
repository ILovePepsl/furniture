class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :manufacturer, class_name: 'User'
end
