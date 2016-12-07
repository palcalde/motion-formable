module MotionForms
  class Row
    attr_accessor :fields,
                  :cell,
                  :inline_cell,
                  :inline_cell_opts,
                  :section,
                  :title,
                  :disabled,
                  :hidden,
                  :subform,
                  :key

    def disabled?
      !!@disabled
    end

    def hidden?
      !!@hidden
    end

    def initialize(opts = {})
      self.cell = opts[:cell] || {}
      self.section = opts[:section]
      self.key = opts[:key]
      self.fields = []
      self.title = opts[:title]
      self.disabled = opts[:disabled] || false
      self.hidden = opts[:hidden] || false
      if opts[:fields]
        opts[:fields].each do |field|
          field[:row] = self
          self.fields << Field.new(field)
        end
      end
      self.cell[:class] ||= BaseCell
      self.cell[:row] = self
      if opts[:selector_controller]
        self.cell[:on_select] = proc do
          controller = opts[:selector_controller].alloc.initWithStyle(UITableViewStyleGrouped)
          controller.fields = self.fields
          if opts[:selector_presentation] == :modal
            self.section.form.controller.presentViewController(controller, animated:true, completion:nil)
          else
            self.section.form.controller.navigationController.pushViewController(controller, animated: true)
          end
        end
      end
      self.subform = Form.new(opts[:subform]) if opts[:subform]
      if opts[:subform_controller]
        self.cell[:on_select] = proc do
          controller = opts[:subform_controller].alloc.initWithStyle(UITableViewStyleGrouped)
          controller.form = self.subform
          if opts[:subform_presentation] == :modal
            self.section.form.controller.presentViewController(controller, animated:true, completion:nil)
          else
            self.section.form.controller.navigationController.pushViewController(controller, animated: true)
          end
        end
      end

      self.cell[:cell] = self.cell_instance
    end

    def cell_instance
      @cell_instance ||= begin
        cell_type = cell[:type] || UITableViewCellStyleDefault
        klass = cell[:class] || UITableViewCell
        cell_instance = klass.alloc.initWithStyle(cell_type, reuseIdentifier:nil)
        Object.apply_hash(cell_instance, cell)
        cell_instance.on_create if cell_instance.respond_to?(:on_create)
        action = cell[:on_create]
        if action.is_a?(Proc)
          action.call(cell, cell_instance)
        elsif action.is_a?(Symbol) && self.section.form.controller.respond_to?(action)
          self.section.form.controller.send(action)
        end
        cell_instance
      end
    end

    def errors
      errors = []
      fields.map do |field|
        field_errors = field.errors
        errors << { key: field.key, errors: field_errors } if field_errors.any?
      end
      errors
    end

    def to_hash
      hashes = fields.map(&:to_hash)
      hashes << subform.to_hash if subform
      hash = hashes.inject({}, &:merge)
      key ? { key => hash } : hash
    end

    def to_row_hash
      hash = {}
      self.fields.each do |field|
        hash[field.key] = self
      end
      key ? { key => hash } : hash
    end

    def to_field_hash
      hashes = fields.map(&:to_field_hash)
      hashes << subform.to_field_hash if subform
      hash = hashes.inject({}, &:merge)
      key ? { key => hash } : hash
    end
  end
end
