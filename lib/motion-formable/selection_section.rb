module MotionFormable
  class SelectionSection < Section
    attr_accessor :multiselection

    def initialize(opts = {})
      super
      self.multiselection = opts[:multiselection]
      opts[:options].each do |option|
        self.rows << Row.new(
          fields: [{ key: option[:key], value: option[:value] }],
          cell: {
            class: CheckCell,
            textLabel: { text: option[:title] },
            on_select: proc do |_, cell, _|
              if self.multiselection
                rows.each do |row|
                  row.fields.first.value = false
                end
                cell.fields.first.value = true
                form.update_cells_in_section(self)
              end
              cell.setSelected(false, animated: true)
            end
          }
        )
      end
    end
  end
end
