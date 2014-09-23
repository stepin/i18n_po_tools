class Hash

  def implode(divider = '.')
    Hash.implode(self, divider)
  end

  def explode(divider = '.')
    Hash.explode(self, divider)
  end

  protected
  def self.implode(hash, divider = '.', recursive_key = "")
    hash.each_with_object({}) do |(k, v), ret|
      key = recursive_key + k.to_s
      if v.is_a? Hash
        ret.merge! implode(v, divider, key + divider)
      else
        ret[key] = v
      end
    end
  end

  def self.explode(hash, divider = '.')
    hash.each_with_object({}) do |(k, v), ret|
      path = k.split(divider)
      h = ret
      path[0...-1].each do |path_part|
        h[path_part] = {} if h[path_part].nil?
        h = h[path_part]
      end
      h[path.last] = v
    end
  end
end