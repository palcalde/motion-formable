module MotionForms
  class BaseCell < UITableViewCell
    attr_accessor :row

    # Called when the cell is created.
    def on_create
      # raise "You must implement `on_create` in your BaseCell subclass"
    end

    def fields
      self.row.fields
    end

    def validate!
      # if fields && fields.any? && fields.map(&:errors).flatten.any?
      #   self.backgroundColor = UIColor.redColor.colorWithAlphaComponent(0.3)
      # else
      #   self.backgroundColor = UIColor.whiteColor
      # end
    end

    def update!
      # raise "You must implement `update!` in your BaseCell subclass"
    end

    # Called when the cell view is going to be reused. Reset all UI state.
    def prepareForReuse; end

    # Called before the cell is displayed. Used to assign the values to UI elements
    def on_display
      update!
    end

    def becomeFirstResponder
      result = super
      highlight if result
      result
    end

    def resignFirstResponder
      result = super
      unhighlight if result
      result
    end

    def highlight; end

    def unhighlight; end

    def inputAccessoryView
      row.section.form.controller.navigation_accessory_for_row(row)
    end

    def textFieldShouldBeginEditing(textField)
      # if the row does not specify a return key type, we set next or go
      has_next_row = row.section.form.controller.next_row_for_row(row, :next)
      textField.returnKeyType = has_next_row ? UIReturnKeyNext : UIReturnKeyDone
    end

    def textFieldShouldReturn(textField)
      # go to the next row or execute the send form block
      row.section.form.controller.navigate_to_direction(:next)
    end
  end
end
