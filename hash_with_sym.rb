# make every hash key as symbol
class Hash
  def with_sym
    self.inject({}) { |new_hsh, (k, v)| new_hsh[k.to_sym] = v; new_hsh }
  end
end