module LexemesHelper
  def unbold_pipes (str)
    # Can't seem to do this in one regexp, so we do split/join twice.
      str.
        split('|').
        join("'''|'''").
        split(/(.*\[\[.+?)'''\|'''(.+?\]\].*)/). 
        delete_if {|x| x == "" }.
        join("|")
  end
end