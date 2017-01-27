module MotionFormable
  class Form
    attr_accessor :sections, :controller, :on_save, :table_view_helper

    def initialize(opts = {})
      self.sections = []
      if opts[:sections]
        opts[:sections].each do |section|
          section[:form] = self
          klass = section[:options] ? SelectionSection : Section
          self.sections << klass.new(section)
        end
      end
      self.controller = opts[:controller]
      self.table_view_helper = TableViewHelper.new(controller.tableView) if controller
      self.on_save = opts[:on_save]
    end

    def visible_sections
      self.sections.reject(&:hidden?)
    end

    def errors
      sections.map(&:errors).flatten
    end

    def to_hash
      hashes = sections.map(&:to_hash)
      HashHelper.merge_hashes(hashes)
    end

    def to_field_hash
      hashes = sections.map(&:to_field_hash)
      HashHelper.merge_hashes(hashes)
    end

    def to_row_hash
      hashes = sections.map(&:to_row_hash)
      HashHelper.merge_hashes(hashes)
    end

    def to_table_hash
      { sections: visible_sections.map(&:to_table_hash) }
    end


    def row_for_index(index)
      self.sections[index.section].rows[index.row]
    end

    def next_row(row)
      index = index_for_row(row)
      row_index = index.row
      section_index = index.section

      if !(next_row = self.sections[section_index].rows[row_index + 1]).nil?
        next_row
      elsif !(next_section = self.sections[section_index + 1]).nil?
        next_section.rows.first
      end
    end

    def previous_row(row)
      index = index_for_row(row)
      row_index = index.row
      section_index = index.section

      if row_index > 0
        self.sections[section_index].rows[row_index - 1]
      elsif section_index > 0
        self.sections[section_index - 1].rows.last
      end
    end

    def validate!
      self.sections.each do |section|
        section.visible_rows.each do |row|
          row.cell_instance.validate!
        end
      end
    end

    def row_with_tag(tag)
      self.sections.map(&:rows).flatten.detect { |r| r.tag == tag }
    end

    def update_dependents_of(tag)
      self.sections.map(&:rows).flatten.each do |row|
        if row.depends_on && row.depends_on.include?(tag)
          row.evaluate_hidden
          row.evaluate_disabled
        end
      end
    end

    def index_for_row(row)
      section_index = sections.index(row.section)
      row_index = row.section.rows.index(row)
      NSIndexPath.indexPathForRow(row_index, inSection:section_index)
    end

    def insert_row(row, index)
      section = sections[index.section]
      row[:section] = section
      row = Row.new(row)
      section.rows.insert(index.row, row)

      self.table_view_helper.insert_row(row, index) if self.table_view_helper
    end

    def show_row(row, index)
      self.table_view_helper.insert_row(row, index) if self.table_view_helper
    end

    def remove_row(row)
      index = index_for_row(row)
      self.table_view_helper.remove_row(row, index) if self.table_view_helper

      row.section.rows.delete(row)
    end

    def hide_row(row)
      index = index_for_row(row)
      self.table_view_helper.remove_row(row, index) if self.table_view_helper
    end

    def insert_section(section, index)
      section[:form] = self
      section = Section.new(section)
      sections.insert(index, section)

      self.table_view_helper.insert_section(section, index) if self.table_view_helper
    end

    def remove_section(section)
      self.table_view_helper.remove_section(section, sections.index(section)) if self.table_view_helper
      sections.delete(section)
    end

    def move_row(from_index, to_index)
      from_section = sections[from_index.section]
      to_section = sections[to_index.section]
      from_section.rows[from_index.row], to_section.rows[to_index.row] = to_section.rows[to_index.row], from_section.rows[from_index.row]

      self.table_view_helper.move_row(from_index, to_index) if self.table_view_helper
    end

    def move_section(from_index, to_index)
      sections[from_index], sections[to_index] = sections[to_index], sections[from_index]

      self.table_view_helper.move_section(from_index, to_index) if self.table_view_helper
    end
  end
end
