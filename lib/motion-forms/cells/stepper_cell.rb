#
# A cell with a stepper to select numerical values
#
# ┌───────────────────────────────┐
# │                     ╭───┬───╮ │
# │ Title            3  │ − │ + │ │
# │                     ╰───┴───╯ │
# └───────────────────────────────┘
#
# /images/cells/stepper_cell.gif
#
module MotionForms
  class StepperCell < BaseCell

    attr_accessor :step_control, :current_step_value

    def on_create
      self.step_control = UIStepper.new
      self.step_control.translatesAutoresizingMaskIntoConstraints = false
      self.step_control.addTarget(self, action:"valueChanged:", forControlEvents:UIControlEventValueChanged)
      self.current_step_value = UILabel.new
      self.current_step_value.translatesAutoresizingMaskIntoConstraints = false

      self.selectionStyle = UITableViewCellSelectionStyleNone
      self.contentView.addSubview(self.step_control)
      self.contentView.addSubview(self.current_step_value)

      self.contentView.addConstraint(NSLayoutConstraint.constraintWithItem(self.step_control,
        attribute:NSLayoutAttributeCenterY, relatedBy:NSLayoutRelationEqual,
        toItem:self.contentView, attribute:NSLayoutAttributeCenterY, multiplier:1, constant:0))

      self.contentView.addConstraint(NSLayoutConstraint.constraintWithItem(self.current_step_value,
         attribute: NSLayoutAttributeCenterY,
         relatedBy: NSLayoutRelationEqual,
         toItem: self.contentView,
         attribute: NSLayoutAttributeCenterY,
         multiplier: 1,
         constant: 0))

      self.contentView.addConstraint(NSLayoutConstraint.constraintWithItem(self.current_step_value,
         attribute: NSLayoutAttributeHeight,
         relatedBy: NSLayoutRelationEqual,
         toItem: self.step_control,
         attribute: NSLayoutAttributeHeight,
         multiplier:1,
         constant:0))

      views = { "value" => self.current_step_value, "control" => self.step_control }
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[value]-5-[control]-|",
        options:0, metrics:0, views:views))
    end

    def update!
      self.textLabel.text = self.row.title if self.row.title
      self.step_control.value = fields.first.value
      self.current_step_value.text = fields.first.value.to_s
      self.step_control.enabled = !self.row.disabled?
      self.current_step_value.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    end

    def valueChanged(sender)
      fields.first.value = self.step_control.value.to_i
      self.current_step_value.text = self.step_control.value.to_i.to_s
    end

  end
end
