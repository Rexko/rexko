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
    groups = senses.collect do |sense|
      optgroup = "%s: %s %s" % [
        sense.lexeme.dictionaries.first.title,
        sense.subentry.paradigm,
        ("(" + sense.subentry.part_of_speech + ")" if sense.subentry.part_of_speech)
        ]

      [optgroup, sense.definition, sense.id]
    end
    
    output = {}
    
    groups.each do |group|
      if output.has_key? group.first
        output[group.first] << [group.second, group.last]
      else
        output[group.first] = [[group.second, group.last]]
      end
    end
    
    output.to_a
  end
end
