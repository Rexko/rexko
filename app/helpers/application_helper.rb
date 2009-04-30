# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def lang_for languable, subtags = {}
    return if languable.language.nil?
    langtag = languable.language
    langtag += "-" + subtags[:variant] unless subtags[:variant].nil?
    "lang=\"#{langtag}\""
  end
  
  def attr_trail *args
    # if 3
    # top level arg is "#{arg.to_s}[\#{@#{arg.to_s}.id}]"
    # mid level arg is "[#{arg.to_s}][\#{@#{arg.to_s}.id}]"
    # last arg is "[#{arg.to_s}][]"
    
    # if 2
    # top level arg is "#{arg.to_s}[\#{@#{arg.to_s}.id}]"
    # last arg is "[#{arg.to_s}][]"

    # if 1 (shouldn't be, but...)
    # last arg is "#{arg.to_s}[]"

    case args.size
    when 1 then return "#{args.first}[]"
    when 2 then return "#{args.last}[#{args.first}][]"
    else 
      outputtail = "[#{args.first}][]"
      args.delete args.first
      output = "#{args.last}"
      args.delete args.last
      for arg in args
        outputtail = "[#{arg}][#{instance_variable_get("@#{arg}").id}]" + outputtail
      end
      return "#{output + outputtail}"
    end
  end
end