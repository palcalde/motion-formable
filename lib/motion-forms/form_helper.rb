module MotionForms
  module FormHelper
    attr_accessor :form

    def data_source
      @data_source ||= (form.to_table_hash if form)
    end

    def row_navigation_done
      self.tableView.endEditing(true)
    end

    def navigation_accessory_for_row(row)
      return unless row.cell_instance.canBecomeFirstResponder
      self.navigation_accessory_view.tap do |view|
        view.next_button.enabled = !self.next_row_for_row(row, :next).nil?
        view.previous_button.enabled = !self.next_row_for_row(row, :previous).nil?
      end
    end

    def navigation_accessory_view
      @navigation_accessory_view ||= Toolbar.new.tap do |t|
        t.previous_button.target = self
        t.previous_button.action = "row_navigation_action:"
        t.next_button.target = self
        t.next_button.action = "row_navigation_action:"
        t.done_button.target = self
        t.done_button.action = "row_navigation_done"
      end
    end

    def row_navigation_action(sender)
      direction = sender == self.navigation_accessory_view.next_button ? :next : :previous
      self.navigate_to_direction(direction)
    end

    def navigate_to_direction(direction)
      first_responder = self.tableView.findFirstResponder
      current_cell = first_responder.parent_cell
      current_index_path = self.tableView.indexPathForCell(current_cell)
      current_row = self.form.row_for_index(current_index_path)
      next_row = self.next_row_for_row(current_row, direction)

      if next_row
        cell = next_row.cell_instance
        if cell.canBecomeFirstResponder
          index_path = self.form.index_for_row(next_row)
          self.tableView.scrollToRowAtIndexPath(index_path, atScrollPosition:UITableViewScrollPositionNone, animated:false)
          cell.becomeFirstResponder
        end
      elsif self.form.on_save
        self.form.on_save.call
      end
    end

    def next_row_for_row(row, direction)
      next_row = direction == :next ? self.form.next_row(row) : self.form.previous_row(row)
      return unless next_row
      if !next_row.disabled? && next_row.cell_instance.canBecomeFirstResponder
        next_row
      else
        next_row_for_row(next_row, direction)
      end
    end
  end
end
