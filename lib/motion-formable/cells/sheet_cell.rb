#
# A cell which shows a sheet to pick between several options
#
# ┌──────────────────────┐
# │ Title          Value │
# └──────────────────────┘
#
# On tap shows a sheet from the bottom:
#
#    ╭─────────────────╮
#    │    Option 1     │
#    ├─────────────────┤
#    │    Option 2     │
#    ├─────────────────┤
#    │    Option 3     │
#    ├─────────────────┤
#    │    Option 4     │
#    ╰─────────────────╯
#    ╭─────────────────╮
#    │     Cancel      │
#    ╰─────────────────╯
#
# /images/cells/sheet_cell.gif
#
module MotionFormable
  class SheetCell < BaseCell
    attr_accessor :options

    def update!
      self.selectionStyle = self.row.disabled? ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault
      self.detailTextLabel.text = self.options.detect { |o| o[:value] == fields.first.value }[:title]
    end

    def on_select
      if NSClassFromString("UIAlertController")
        controller = self.row.section.form.controller
        alertController = UIAlertController.alertControllerWithTitle(self.row.title,
          message:nil, preferredStyle:UIAlertControllerStyleActionSheet)
        alertController.addAction(UIAlertAction.actionWithTitle(NSLocalizedString("Cancel", nil),
          style:UIAlertActionStyleCancel, handler:nil))

        self.options.each do |option|
          alertController.addAction(UIAlertAction.actionWithTitle(option[:title],
            style:UIAlertActionStyleDefault, handler: proc do |action|
              fields.first.value = option[:value]
              self.row.section.form.controller.tableView.reloadData
            end))
        end
        controller.presentViewController(alertController, animated:true, completion:nil)
      else
        actionSheet = UIActionSheet.alloc.initWithTitle(self.rowDescriptor.selectorTitle,
          delegate:self, cancelButtonTitle:nil, destructiveButtonTitle:nil, otherButtonTitles:nil)

        self.options.each do |option|
          actionSheet.addButtonWithTitle(option[:title])
        end

        actionSheet.cancelButtonIndex = actionSheet.addButtonWithTitle(NSLocalizedString("Cancel", nil))
        actionSheet.showInView(row.section.form.controller.view)
      end

      index = row.section.form.controller.tableView.indexPathForCell(self)
      row.section.form.controller.tableView.deselectRowAtIndexPath(index, animated:true)
    end

    def actionSheet(actionSheet, clickedButtonAtIndex:buttonIndex)
      return unless actionSheet.cancelButtonIndex != buttonIndex
      title = actionSheet.buttonTitleAtIndex(buttonIndex)
      option = self.options.detect { |o| o[:title] == title }
      fields.first.value = option[:value]
      self.row.section.form.controller.tableView.reloadData
    end
  end
end
