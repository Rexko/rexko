module SortOrdersHelper
  def friendly_subst hsh
    hsh.inject("") do |memo, (orig,xform)|
      "#{memo}\n#{orig} #{xform}"
    end
  end
  
  def friendly_order hsh
    hsh.inject("") do |memo, (latter,former)|
      "#{memo}\n#{former} #{latter}"
    end
  end
end
