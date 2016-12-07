module MotionForms
  class Form
    attr_accessor :sections, :controller, :on_save

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

    ################
    ##### iOS ######
    ################

    def index_for_row(row)
      section_index = sections.index(row.section)
      row_index = row.section.rows.index(row)
      NSIndexPath.indexPathForRow(row_index, inSection:section_index)
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

    def insert_row(row, index)
      section = sections[index.section]
      row[:section] = section
      row = Row.new(row)
      section.rows.insert(index.row, row)
      # insert row in table
    end

    def remove_row(row)
      row.section.rows.delete(row)
      # remove row from table
    end

    def insert_section(section, index)
      section[:form] = self
      section = Section.new(section)
      sections.insert(index, section)
      # insert section in table
    end

    def remove_section(section)
      sections.delete(section)
      # remove section from table
    end

    def move_row(from_index, to_index)
      from_section = sections[from_index.section]
      to_section = sections[to_index.section]
      from_section.rows[from_index.row], to_section.rows[to_index.row] = to_section.rows[to_index.row], from_section.rows[from_index.row]
      # move row in table
    end

    def move_section(from_index, to_index)
      sections[from_index], sections[to_index] = sections[to_index], sections[from_index]
      # move section in table
    end

    def validate!
      self.sections.each do |section|
        section.visible_rows.each do |row|
          row.cell_instance.validate!
        end
      end
    end
  end
end
