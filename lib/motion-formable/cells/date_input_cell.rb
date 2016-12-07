#
# A cell which shows a date picker view to pick a date, time, datetime or coundown.
#
# ┌──────────────────────┐
# │ Title           Date │
# └──────────────────────┘
#
# On tap shows a date picker:
#
# ┌──────────────────────┐
# │⟨ ⟩              Done │
# ├──────────────────────┤
# │ April     28    2014 │
# │ May       29    2015 │
# ├──────────────────────┤
# │ June      30    2016 │
# ├──────────────────────┤
# │ July      31    2017 │
# │ August     1    2018 │
# └──────────────────────┘
#
# /images/cells/date_input_cell.gif
#
module MotionFormable
  class DateInputCell < BaseCell
    attr_accessor :date_picker,
                  :date_picker_mode,
                  :minute_interval,
                  :minimum_date,
                  :maximum_date

    def on_create
      self.date_picker = UIDatePicker.new
      self.date_picker.addTarget(self, action:"datePickerValueChanged:", forControlEvents:UIControlEventValueChanged)
      self.date_picker.datePickerMode = self.date_picker_mode
      self.date_picker.minuteInterval = self.minute_interval if self.minute_interval
      self.date_picker.minimumDate = self.minimum_date if self.minimum_date
      self.date_picker.maximumDate = self.maximum_date if self.maximum_date
    end

    def update!
      self.accessoryType = UITableViewCellAccessoryNone
      self.editingAccessoryType = UITableViewCellAccessoryNone
      self.textLabel.text = self.row.title if self.row.title
      self.selectionStyle = self.row.disabled? ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault
      self.detailTextLabel.text = date_formatted
    end

    def on_select
      self.becomeFirstResponder
      self.setSelected(false, animated: true)
    end

    def canBecomeFirstResponder
      !self.row.disabled?
    end

    def inputView
      date_picker
    end

    def date_formatted
      date = fields.first.value
      return if date.nil?
      case self.date_picker_mode
      when UIDatePickerModeDate
        NSDateFormatter.localizedStringFromDate(date, dateStyle:NSDateFormatterMediumStyle, timeStyle:NSDateFormatterNoStyle)
      when UIDatePickerModeTime
        NSDateFormatter.localizedStringFromDate(date, dateStyle:NSDateFormatterNoStyle, timeStyle:NSDateFormatterShortStyle)
      when UIDatePickerModeCountDownTimer
        time = NSCalendar.currentCalendar.components(NSCalendarUnitHour | NSCalendarUnitMinute, fromDate:date)
        format("%s%s %smin", time.hour, time.hour == 1 ? "hour" : "hours", time.minute)
      else # UIDatePickerModeDateAndTime
        NSDateFormatter.localizedStringFromDate(date, dateStyle:NSDateFormatterShortStyle, timeStyle:NSDateFormatterShortStyle)
      end
    end

    def datePickerValueChanged(datePicker)
      fields.first.value = datePicker.date
      update!
    end

    def highlight
      self.detailTextLabel.textColor = self.tintColor
    end

    def unhighlight
      self.detailTextLabel.textColor = UIColor.blackColor
    end
  end
end
