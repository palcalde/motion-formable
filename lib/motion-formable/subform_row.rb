module MotionFormable
  class SubformRow
    attr_accessor :key, :cell, :section, :subform

    def initialize(opts = {})
      self.cell = opts[:cell] || {}
      self.section = opts[:section]
      self.subform = Form.new(opts[:subform]) if opts[:subform]
      self.cell[:class] ||= BaseCell
    end

    def errors
      subform.errors
    end
  end
end
