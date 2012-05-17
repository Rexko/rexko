module ParsableHelper
	def display_obj_of parse
		case parse.parsable_type
		when "Attestation"
			parse.parsable.locus || parse.parsable
		else
			parse.parsable
		end	
	end
end
