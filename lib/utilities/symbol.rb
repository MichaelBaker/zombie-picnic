class Symbol
  def constantize
    self.to_s.constantize.to_sym
  end
end