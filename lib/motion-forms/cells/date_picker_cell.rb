#
# A cell which shows a date picker view to pick a date, time, datetime or coundown.
#
# ┌──────────────────────┐
# │ April     28    2014 │
# │ May       29    2015 │
# ├──────────────────────┤
# │ June      30    2016 │
# ├──────────────────────┤
# │ July      31    2017 │
# │ August     1    2018 │
# └──────────────────────┘
#
# /images/cells/date_picker_cell.gif
#
module MotionForms
  class DatePickerCell < BaseCell

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
      self.date_picker.translatesAutoresizingMaskIntoConstraints = false
      self.date_picker.delegate = self
      self.contentView.addSubview(self.date_picker)
      self.contentView.addConstraint(NSLayoutConstraint.constraintWithItem(self.date_picker,
        attribute:NSLayoutAttributeCenterX, relatedBy:NSLayoutRelationEqual,
        toItem:self.contentView, attribute:NSLayoutAttributeCenterX, multiplier:1, constant:0))
      views = { "pickerView" => self.date_picker }
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[pickerView]-0-|",
        options:0, metrics:0, views:views))
      self.row.cell[:height] = 216
    end

    def update!
      disabled = self.row.disabled?
      self.userInteractionEnabled = !disabled
      self.contentView.alpha = disabled ? 0.5 : 1.0
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
        "%s%s %smin" % [time.hour, time.hour == 1 ? "hour" : "hours", time.minute]
      else # UIDatePickerModeDateAndTime
        NSDateFormatter.localizedStringFromDate(date, dateStyle:NSDateFormatterShortStyle, timeStyle:NSDateFormatterShortStyle)
      end
    end

    def datePickerValueChanged(datePicker)
      fields.first.value = datePicker.date
    end

  end
end
