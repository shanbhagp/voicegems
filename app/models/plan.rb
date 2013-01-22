class Plan < ActiveRecord::Base
  attr_accessible :events_number, :monthly_cost_cents, :name, :trial_period
end
