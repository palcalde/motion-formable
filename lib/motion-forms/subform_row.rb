module MotionForms
  class SubformRow
    attr_accessor :key, :cell, :section, :subform

    def initialize(opts = {})
      self.cell = opts[:cell] || {}
      self.section = opts[:section]
      if opts[:subform]
        self.subform = Form.new(opts[:subform])
      end
      self.cell[:class] ||= BaseCell
    end

    def errors
      subform.errors
    end
  end
end
