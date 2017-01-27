#
# A cell with a label on the left side and a UISwich on the right side
#
# ┌───────────────────────────────┐
# │                      ╭───────╮│
# │ Title                │ ◯     ││
# │                      ╰───────╯│
# └───────────────────────────────┘
#
# /images/cells/switch_cell.png
#
module MotionFormable
  class SwitchCell < BaseCell
    def on_create
      self.selectionStyle = UITableViewCellSelectionStyleNone
      self.accessoryView = UISwitch.alloc.init
      self.editingAccessoryView = self.accessoryView
      self.switch_control.addTarget(self, action: :value_changed, forControlEvents:UIControlEventValueChanged)
    end

    def update!
      self.textLabel.text = self.row.title if self.row.title
      self.switch_control.on = !!self.fields.first.value
      self.switch_control.enabled = !self.row.disabled?
    end

    def switch_control
      accessoryView
    end

    def value_changed
      self.fields.first.update_value self.switch_control.on?
    end
  end
end
