module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def getClass(arg)
    if (params[:field]==arg) 
      return "hilite"
      
    else
      return nil
    end
  end  
  
  def getChecked(arg)
    @ratings.include?(arg)
  end  
end
