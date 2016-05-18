#
# A cell with a segmented control to pick different options
#
# ┌───────────────────────────────┐
# │           ╭─────┬─────┬─────╮ │
# │ Title     │ Abc │ Def │ Ghi │ │
# │           ╰─────┴─────┴─────╯ │
# └───────────────────────────────┘
#
# /images/cells/segmented_cell.gif
#
module MotionForms
  class SegmentedCell < BaseCell
    attr_accessor :dynamic_constraints, :text_label, :segmented_control, :options

    def on_create
      self.segmented_control = UISegmentedControl.new
      self.segmented_control.translatesAutoresizingMaskIntoConstraints = false
      self.segmented_control.setContentHuggingPriority(500, forAxis:UILayoutConstraintAxisHorizontal)
      self.text_label = UILabel.new
      self.text_label.translatesAutoresizingMaskIntoConstraints = false
      self.text_label.setContentCompressionResistancePriority(500, forAxis:UILayoutConstraintAxisHorizontal)
      self.selectionStyle = UITableViewCellSelectionStyleNone
      self.contentView.addSubview(self.segmented_control)
      self.contentView.addSubview(self.text_label)
      self.segmented_control.addTarget(self, action:"value_changed", forControlEvents:UIControlEventValueChanged)
    end

    def updateConstraints
      if self.dynamic_constraints
        self.contentView.removeConstraints(self.dynamic_constraints)
      end
      self.dynamic_constraints = []

      views = { "segmented_control" => self.segmented_control, "text_label" => self.text_label }
      constraints_block = proc do |format, options|
        NSLayoutConstraint.constraintsWithVisualFormat(format, options:options, metrics:nil, views:views)
      end

      if self.text_label.text.length > 0
        self.dynamic_constraints.concat(constraints_block.call("H:|-[text_label]-16-[segmented_control]-|", NSLayoutFormatAlignAllCenterY))
        self.dynamic_constraints.concat(constraints_block.call("V:|-12-[text_label]-12-|", 0))
      else
        self.dynamic_constraints.concat(constraints_block.call("H:|-[segmented_control]-|", NSLayoutFormatAlignAllCenterY))
        self.dynamic_constraints.concat(constraints_block.call("V:|-[segmented_control]-|", 0))
      end
      self.contentView.addConstraints(self.dynamic_constraints)
      super
    end

    def update!
      self.text_label.text = self.row.title if self.row.title
      self.update_segmented_control
      self.segmented_control.selectedSegmentIndex = selected_index || UISegmentedControlNoSegment
      self.segmented_control.enabled = !self.row.disabled?
      setNeedsUpdateConstraints
    end

    def update_segmented_control
      self.segmented_control.removeAllSegments
      self.options.each_with_index do |option, index|
         self.segmented_control.insertSegmentWithTitle(option[:title], atIndex:index, animated:false)
      end
    end

    def selected_index
      if value = fields.first.value
        option = self.options.detect { |o| o[:value] == value }
        options.index(option)
      end
    end

    def value_changed
      fields.first.value = self.options[self.segmented_control.selectedSegmentIndex][:value]
    end

  end
end
