# encoding: utf-8

module LociHelper
  def greek_numeral(int)
    "%s%s%s%sʹ" % [
      ['', '͵α', '͵β', '͵γ', '͵δ', '͵ε', '͵στ', '͵ζ', '͵η', '͵θ'][int / 1000 % 10],
      ['', 'ρ', 'σ', 'τ', 'υ', 'φ', 'χ', 'ψ', 'ω', 'ϡ'][int / 100 % 10],
      ['', 'ι', 'κ', 'λ', 'μ', 'ν', 'ξ', 'ο', 'π', 'ϟ'][int / 10 % 10],
      ['', 'α', 'β', 'γ', 'δ', 'ε', 'στ', 'ζ', 'η', 'θ'][int % 10]
    ]
  end
  
  def sense_select(senses)
  	new_senses = {}
  
    groups = senses.collect do |sense|
      optgroup = "%s: %s %s" % [
        (sense.lexeme.dictionaries.first.try(:title) || "(No dictionary)"),
        sense.subentry.paradigm,
        ("(" + sense.subentry.part_of_speech + ")" if sense.subentry.part_of_speech)
        ]

			# need to set id or otherwise make it optionable
			new_senses[optgroup] = sense.subentry.senses.build(:definition => "(new sense under this subentry...)")

      [optgroup, sense.definition, sense.id]
    end
    
    output = {}
    
    groups.each do |group|
      if output.has_key? group.first # if we already have optgroup X, append
        output[group.first] << [group.second, group.last]
      else # otherwise, create optgroup X
        output[group.first] = [[group.second, group.last]]
      end
    end
    
    output.each do |k_group, v_members|
    	v_members << [new_senses[k_group].definition, "new-%d" % new_senses[k_group].subentry.id]
    end
    
    output.to_a
  end
end
