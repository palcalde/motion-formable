module MotionFormable
  class TableViewHelper
    attr_accessor :table_view

    def initialize(table_view)
      self.table_view = table_view
    end

    def insert_row(row, index)
      self.table_view.beginUpdates
      self.table_view.insertRowsAtIndexPaths([index], withRowAnimation:UITableViewRowAnimationFade)
      self.table_view.endUpdates
    end

    def remove_row(row, index)
      self.table_view.beginUpdates
      self.table_view.deleteRowsAtIndexPaths([index], withRowAnimation:UITableViewRowAnimationFade)
      self.table_view.endUpdates
    end

    def insert_section(section, index)
      self.table_view.beginUpdates
      self.table_view.insertSections(NSIndexSet.indexSetWithIndex(index), withRowAnimation:UITableViewRowAnimationFade)
      self.table_view.endUpdates
    end

    def remove_section(section, index)
      self.table_view.beginUpdates
      self.table_view.deleteSections(NSIndexSet.indexSetWithIndex(index), withRowAnimation:UITableViewRowAnimationFade)
      self.table_view.endUpdates
    end

    def move_row(from_index, to_index)
      self.table_view.moveRowAtIndexPath(from_index, toIndexPath:to_index)
    end

    def move_section(from_index, to_index)
      self.table_view.moveSection(from_index, toSection:to_index)
    end

    def update_data_source
      self.table_view.dataSource.update_data_source
    end
  end
end
