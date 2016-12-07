#
# A cell which shows a popover pick between several options
#
# NOTE: Only for iPad
#
# ┌──────────────────────┐
# │ Title          Value │
# └──────────────────────┘
#
# On tap shows a popover:
#
#    ╭─────────────────╮
#    ├─────────────────┤
#    │    Option 1     │
#    ├─────────────────┤
#    │    Option 2     │▶︎
#    ├─────────────────┤
#    │    Option 3     │
#    ├─────────────────┤
#    │    Option 4     │
#    ├─────────────────┤
#    ╰─────────────────╯
#
# /images/cells/popover_cell.gif
#
module MotionFormable
  class PopoverCell < BaseCell
    attr_accessor :options, :popover_controller

    def update!
      self.selectionStyle = self.row.disabled? ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault
      self.detailTextLabel.text = fields.first.value.to_s
    end

    def on_select
      if self.popover_controller && self.popover_controller.popoverVisible
        self.popover_controller.dismissPopoverAnimated(false)
      end

      controller = self.row.selector_controller || self.row.subform_controller

      self.popover_controller = UIPopoverController.alloc.initWithContentViewController(controller)
      self.popover_controller.delegate = self

      if self.detailTextLabel.window
        self.popover_controller.presentPopoverFromRect([[0, 0], self.detailTextLabel.frame.size],
          inView:self.detailTextLabel, permittedArrowDirections:UIPopoverArrowDirectionAny, animated:true)
      else
        self.popover_controller.presentPopoverFromRect([[0, 0], self.frame.size],
          inView:self, permittedArrowDirections:UIPopoverArrowDirectionAny, animated:true)
      end

      index = row.section.form.controller.tableView.indexPathForCell(self)
      row.section.form.controller.tableView.deselectRowAtIndexPath(index, animated:true)
    end

    def popoverControllerDidDismissPopover(popoverController)
      self.row.section.form.controller.tableView.reloadData
    end
  end
end
