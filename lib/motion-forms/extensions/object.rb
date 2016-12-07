class Object
  def apply_hash(receiver, attributes = {})
    attributes.each do |attribute, value|
      if value.is_a? Hash
        getter = attribute.to_s
        apply_hash(receiver.send(getter), value) if receiver.respond_to?(getter)
      else
        setter = "#{attribute}="
        receiver.send(setter, value) if receiver.respond_to?(setter)
      end
    end
  end
end
