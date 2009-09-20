module LexemesHelper
  # Do wikibold around a string, except around the | character, unless it's the |
  # that does pipe-linking.  This approach thanks to Ben Marini's suggestion at
  # http://refactormycode.com/codes/977-ugly-split-join
  def bold_around_pipes (str)
    stack, functional = 0, false
    "'''#{str}'''".each_char.inject('') do |memo, char|
      case char
      when '[' then stack, functional = stack + 1, true
      when ']' then stack, functional = stack - 1, !stack.zero?
      when '|' then stack.zero? || !functional ? char = "'''|'''" : functional = false
      end
      memo + char
    end
  end
end