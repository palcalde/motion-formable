#
# A cell with toggle checkmark on the right
#
# ┌──────────────────────┐
# │ Title              ✓ │
# └──────────────────────┘
#
# /images/cells/check_cell.png
#
module MotionFormable
  class CheckCell < BaseCell
    def update!
      self.textLabel.text = self.row.title if self.row.title
      type = fields.first.value == true ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone
      self.accessoryType = type
      self.editingAccessoryType = type
    end

    def on_select
      fields.first.value = !fields.first.value
      self.setSelected(false, animated: true)
      update!
    end
  end
end
