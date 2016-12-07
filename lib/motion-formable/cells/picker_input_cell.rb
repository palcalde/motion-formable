#
# A cell which shows a picker view to pick between several options
#
# ┌──────────────────────┐
# │ Title          Value │
# └──────────────────────┘
#
# On tap shows a picker:
#
# ┌──────────────────────┐
# │⟨ ⟩              Done │
# ├──────────────────────┤
# │       Option 1       │
# │       Option 2       │
# ├──────────────────────┤
# │       Option 3       │
# ├──────────────────────┤
# │       Option 4       │
# │       Option 5       │
# └──────────────────────┘
#
# /images/cells/picker_input_cell.gif
#
module MotionFormable
  class PickerInputCell < BaseCell
    attr_accessor :options, :picker_view

    def on_create
      self.picker_view = UIPickerView.new
      self.picker_view.delegate = self
      self.picker_view.dataSource = self
    end

    def update!
      if self.selected_index
        self.picker_view.selectRow(self.selected_index, inComponent:0, animated:false)
      end
      selected_option = self.options.detect { |o| o[:value] == fields.first.value }
      self.detailTextLabel.text = selected_option[:title] if selected_option
    end

    def selected_index
      value = fields.first.value
      return unless value
      option = self.options.detect { |o| o[:value] == value }
      options.index(option)
    end

    def on_select
      self.becomeFirstResponder
      index = row.section.form.controller.tableView.indexPathForCell(self)
      row.section.form.controller.tableView.deselectRowAtIndexPath(index, animated:true)
    end

    def inputView
      self.picker_view
    end

    def canBecomeFirstResponder
      true
    end

    def pickerView(pickerView, titleForRow:row, forComponent:component)
      options[row][:title]
    end

    def pickerView(pickerView, didSelectRow:row, inComponent:component)
      option = options[row]
      fields.first.value = option[:value]
      self.detailTextLabel.text = option[:title]
      self.setNeedsLayout
    end

    def numberOfComponentsInPickerView(pickerView)
      1
    end

    def pickerView(pickerView, numberOfRowsInComponent:component)
      options.count
    end
  end
end
