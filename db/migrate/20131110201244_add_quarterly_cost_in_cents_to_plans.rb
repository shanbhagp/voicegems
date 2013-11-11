class AddQuarterlyCostInCentsToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :quarterly_cost_cents, :integer
  end
end
