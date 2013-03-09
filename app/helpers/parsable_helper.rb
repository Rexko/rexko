module ParsableHelper
	def display_obj_of parse
		case parse.parsable_type
		when "Attestation"
			parse.parsable.locus || parse.parsable
		when "Etymology"
			parse.parsable.subentries.try(:first).try(:lexeme) || parse.parsable
		when "Gloss"
		  parse.parsable.sense.try(:lexeme) || parse.parsable
		else
			parse.parsable
		end	
	end
	
	def display_form_for parse
		kind = parse.parsable_type.underscore
		lookup_context.exists?("parsable/" + kind, [], :partial) ? 
			"parsable/" + kind :
			"shared/" + kind
	end
end
