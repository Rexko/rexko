module LociHelper
  def old_greek_numeral str
    str = str.to_s
    ones = ['', 'α', 'β', 'γ', 'δ', 'ε', 'στ', 'ζ', 'η', 'θ']
    tens = ['', 'ι', 'κ', 'λ', 'μ', 'ν', 'ξ', 'ο', 'π', 'ϟ']
    hundreds = ['', 'ρ', 'σ', 'τ', 'υ', 'φ', 'χ', 'ψ', 'ω', 'ϡ']
    str = str.sub(/\d..\z/) { |hundred| hundreds[hundred[0].chr.to_i] + hundred.reverse.chop.reverse }
    str = str.sub( /\d.\z/) { |ten| tens[ten[0].chr.to_i] + ten.reverse.chop.reverse}
    str = str.sub( /\d\z/ ) { |one| ones[one.to_i] }
    str + 'ʹ'
  end
  
  def greek_numeral int
    ones = ['', 'α', 'β', 'γ', 'δ', 'ε', 'στ', 'ζ', 'η', 'θ']
    tens = ['', 'ι', 'κ', 'λ', 'μ', 'ν', 'ξ', 'ο', 'π', 'ϟ']
    hundreds = ['', 'ρ', 'σ', 'τ', 'υ', 'φ', 'χ', 'ψ', 'ω', 'ϡ']
    hundred, int = int.divmod(100)
    ten, one = int.divmod(10)
    str = hundreds[hundred % 10] << tens[ten] << ones[one]
    str + 'ʹ'
  end
end
