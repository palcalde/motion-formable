class HashHelper
  # Used to merge two or more hashes, and merge duplicate keys in an array.
  #
  # Example:
  #
  #   hashes = [
  #     { animal: 'dog', food: 'pizza' },
  #     { animal: 'cat' }
  #   ]
  #   HashHelper.merge_hashes(hashes)
  #   # => { animal: ['dog', 'cat'], food: 'pizza' }
  #
  def self.merge_hashes(hashes)
    hash = {}
    hashes.each do |h|
      h.each do |k, v|
        case hash[k]
        when nil then hash[k] = v
        when Array then  hash[k] << v
        else hash[k] = [hash[k], v]
        end
      end
    end
    hash
  end
end
