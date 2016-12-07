module MotionForms
  class Field
    # @attr [Symbol]
    attr_accessor :key
    # @attr [String, Numeric, Array]
    attr_accessor :value
    # @attr [Hash]
    attr_accessor :validators

    attr_accessor :required

    attr_accessor :row

    attr_accessor :required, :required_message

    def initialize(opts = {})
      self.key = opts[:key]
      self.value = opts[:value]
      self.validators = opts[:validators] || []
      self.row = opts[:row]
      if opts[:required]
        self.required_message = opts[:required_message]
        self.validators << {
          block: proc { |value| !value.nil? && !value.to_s.empty? },
          message: opts[:required_message]
        }
      end
      self.required = opts[:required]
    end

    def update_value(value)
      self.value = value
      row.update!
    end

    def errors
      errors = []
      if validators
        validators.each do |validator|
          errors << validator[:message] unless validator[:block].call(value)
        end
      end
      errors
    end

    def to_hash
      { key => value }
    end

    def to_field_hash
      { key => self }
    end
  end
end
