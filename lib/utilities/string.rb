class String
  def constantize
    self.split("_").map {|part| part.capitalize}.join("")
  end
end