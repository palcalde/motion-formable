#
# A cell which shows an alert view to pick between several options
#
# ┌──────────────────────┐
# │ Title          Value │
# └──────────────────────┘
#
# On tap shows an alert:
#
#    ╭─────────────────╮
#    │    Option 1     │
#    ├─────────────────┤
#    │    Option 2     │
#    ├─────────────────┤
#    │    Option 3     │
#    ├─────────────────┤
#    │    Option 4     │
#    ├─────────────────┤
#    │     Cancel      │
#    ╰─────────────────╯
#
# /images/cells/alert_cell.gif
#
module MotionFormable
  class AlertCell < BaseCell
    attr_accessor :options

    def update!
      self.selectionStyle = self.row.disabled? ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault
      self.detailTextLabel.text = self.options.detect { |o| o[:value] == fields.first.value }[:title]
    end

    def on_select
      if NSClassFromString("UIAlertController")
        controller = self.row.section.form.controller
        alertController = UIAlertController.alertControllerWithTitle(self.row.title,
          message:nil, preferredStyle:UIAlertControllerStyleAlert)
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
        alertView = UIAlertView.alloc.initWithTitle(self.row.title,
          message:nil,
          delegate:self,
          cancelButtonTitle:nil,
          otherButtonTitles:nil)

        self.options.each do |option|
          alertView.addButtonWithTitle(option[:title])
        end
        alertView.cancelButtonIndex = alertView.addButtonWithTitle(NSLocalizedString("Cancel", nil))
        alertView.show
      end

      index = row.section.form.controller.tableView.indexPathForCell(self)
      row.section.form.controller.tableView.deselectRowAtIndexPath(index, animated:true)
    end

    def alertView(alertView, clickedButtonAtIndex:buttonIndex)
      return unless alertView.cancelButtonIndex != buttonIndex
      title = alertView.buttonTitleAtIndex(buttonIndex)
      option = self.options.detect { |o| o[:title] == title }
      fields.first.value = option[:value]
      self.row.section.form.controller.tableView.reloadData
    end
  end
end
