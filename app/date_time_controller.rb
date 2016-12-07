class DateTimeController < UITableViewController
  include MotionIOSTable::TableHelper
  include MotionFormable::FormHelper

  def viewDidLoad
    self.tableView.delegate = self
    self.tableView.dataSource = self

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle('Validate',
      style:UIBarButtonItemStylePlain, target:self, action: :validate_form)
  end


  def viewWillAppear(animated)
    # If a cell is selected, we might be getting back from a subform or selector, so refresh the cell
    if selected = self.tableView.indexPathForSelectedRow
      self.tableView.reloadRowsAtIndexPaths([selected], withRowAnimation:UITableViewRowAnimationNone)
    end
  end

  def validate_form
    p form.fields
    p form.errors
    p form.validate!(self.tableView)
  end

  def form
    @form ||= MotionFormable::Form.new({
      controller: self,
      sections: [
        {
          table_options: {
            header_title: 'Dates'
          },
          rows: [
            {
              fields: [{ key: :date, value: NSDate.date }],
              cell: {
                class: MotionFormable::DateInputCell,
                type: UITableViewCellStyleValue1,
                textLabel: { text: 'Date' },
                date_picker_mode: UIDatePickerModeDate
              }
            },
            {
              fields: [{ key: :date, value: NSDate.date }],
              cell: {
                class: MotionFormable::DateInputCell,
                type: UITableViewCellStyleValue1,
                textLabel: { text: 'Time' },
                date_picker_mode: UIDatePickerModeTime
              }
            },
            {
              fields: [{ key: :date, value: NSDate.date }],
              cell: {
                class: MotionFormable::DateInputCell,
                type: UITableViewCellStyleValue1,
                textLabel: { text: 'Date Time' },
                date_picker_mode: UIDatePickerModeDateAndTime
              }
            },
            {
              fields: [{ key: :date, value: NSDate.date }],
              cell: {
                class: MotionFormable::DateInputCell,
                type: UITableViewCellStyleValue1,
                textLabel: { text: 'Countdown Timer' },
                date_picker_mode: UIDatePickerModeCountDownTimer
              }
            },
          ]
        },
        {
          table_options: {
            header_title: 'Disabled Dates'
          },
          rows: [
            {
              fields: [{ key: :date, value: NSDate.date }],
              disabled: true,
              cell: {
                class: MotionFormable::DateInputCell,
                type: UITableViewCellStyleValue1,
                textLabel: { text: 'Date' },
                date_picker_mode: UIDatePickerModeDate
              }
            },
          ]
        },
        {
          table_options: {
            header_title: 'Datepicker'
          },
          rows: [
            {
              fields: [{ key: :date, value: NSDate.date }],
              cell: {
                class: MotionFormable::DatePickerCell,
                date_picker_mode: UIDatePickerModeDate
              }
            },
          ]
        }
      ]
    })
  end
end
