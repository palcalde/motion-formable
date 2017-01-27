module MotionFormable
  class TableViewHelper
    attr_accessor :controller

    def initialize(controller)
      self.controller = controller
    end

    def tableView
      controller.tableView
    end

    def insert_row(row, index)
      self.tableView.beginUpdates
      self.tableView.insertRowsAtIndexPaths([index], withRowAnimation:UITableViewRowAnimationFade)
      self.tableView.endUpdates
    end

    def remove_row(row)
      index = self.tableView.indexPathForCell(row.cell_instance)
      self.tableView.beginUpdates
      self.tableView.deleteRowsAtIndexPaths([index], withRowAnimation:UITableViewRowAnimationFade)
      self.tableView.endUpdates
    end

    def insert_section(section, index)
      self.tableView.beginUpdates
      self.tableView.insertSections(NSIndexSet.indexSetWithIndex(index), withRowAnimation:UITableViewRowAnimationFade)
      self.tableView.endUpdates
    end

    def remove_section(section, index)
      self.tableView.beginUpdates
      self.tableView.deleteSections(NSIndexSet.indexSetWithIndex(index), withRowAnimation:UITableViewRowAnimationFade)
      self.tableView.endUpdates
    end

    def move_row(from_index, to_index)
      self.tableView.moveRowAtIndexPath(from_index, toIndexPath:to_index)
    end

    def move_section(from_index, to_index)
      self.tableView.moveSection(from_index, toSection:to_index)
    end
  end
end
