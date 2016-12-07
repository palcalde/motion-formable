#
# A cell which shows a picker view to pick between several options
#
# ┌──────────────────────┐
# │       Option 1       │
# │       Option 2       │
# ├──────────────────────┤
# │       Option 3       │
# ├──────────────────────┤
# │       Option 4       │
# │       Option 5       │
# └──────────────────────┘
#
# /images/cells/picker_cell.gif
#
module MotionFormable
  class PickerCell < BaseCell
    attr_accessor :options, :picker_view

    def on_create
      self.picker_view = UIPickerView.new
      self.picker_view.translatesAutoresizingMaskIntoConstraints = false
      self.picker_view.delegate = self
      self.picker_view.dataSource = self
      self.contentView.addSubview(self.picker_view)
      self.contentView.addConstraint(NSLayoutConstraint.constraintWithItem(self.picker_view,
        attribute:NSLayoutAttributeCenterX, relatedBy:NSLayoutRelationEqual,
        toItem:self.contentView, attribute:NSLayoutAttributeCenterX, multiplier:1, constant:0))
      views = { "pickerView" => self.picker_view }
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[pickerView]-0-|",
        options:0, metrics:0, views:views))
      self.row.cell[:height] = 216
    end

    def update!
      if self.selected_index
        self.picker_view.selectRow(self.selected_index, inComponent:0, animated:false)
      end
      disabled = self.row.disabled?
      self.userInteractionEnabled = !disabled
      self.contentView.alpha = disabled ? 0.5 : 1.0
      self.picker_view.selectRow(selected_index, inComponent:0, animated:false)
      self.picker_view.reloadAllComponents
    end

    def selected_index
      value = fields.first.value
      return unless value
      option = self.options.detect { |o| o[:value] == value }
      options.index(option)
    end

    def on_select
      self.becomeFirstResponder
      self.setSelected(false, animated: true)
    end

    def inputView
      self.picker_view
    end

    def canResignFirstResponder
      true
    end

    def canBecomeFirstResponder
      true
    end

    def pickerView(pickerView, titleForRow:row, forComponent:component)
      options[row][:title]
    end

    def pickerView(pickerView, didSelectRow:row, inComponent:component)
      fields.first.value = options[row][:value]
    end

    def numberOfComponentsInPickerView(pickerView)
      1
    end

    def pickerView(pickerView, numberOfRowsInComponent:component)
      options ? options.count : 0
    end
  end
end
