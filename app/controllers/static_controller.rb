class StaticController < ApplicationController

def value
end 

def works
end 

def plantest
end

def terms
end

def cartest
end 

def weddings

	@first_plan = Plan.find_by_my_plan_id(plan_set_one) # sets @first_plan the first plan object ACCORDING TO MY LEGEND (with my_plan_id)
	@second_plan = Plan.find_by_my_plan_id(plan_set_two)
	@third_plan = Plan.find_by_my_plan_id(plan_set_three)

end 

def privacy
end 

def faq
end 

end