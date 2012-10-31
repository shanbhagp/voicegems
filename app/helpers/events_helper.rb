module EventsHelper

#def generate_event_code(x)
#	x.event_code = Digest::SHA1.hexdigest.([Time.now, rand].join)[4..8]
#	if Event.find_by_event_code(x.event_code)
#		generate_event_code(x)
#	end 
#end

#def generate_event_code(x)
#	y = Digest::SHA1.hexdigest.([Time.now, rand].join)[4..8]
#	if Event.find_by_event_code(y)
#		generate_event_code(x)
#	else
#		x.event_code = y
#	end 
# end


# def generate_event_code(x)
#	x.event_code = Digest::SHA1.hexdigest([Time.now, rand].join)[4..8]
# end 

def generate_event_code(x)
	y = Digest::SHA1.hexdigest([Time.now, rand].join)[4..8].upcase

	if Event.find_by_event_code(y)
		generate_event_code(x)
	else
		x.event_code = y
	end 
end 

end 