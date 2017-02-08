module MotionFormable
  class Form
    attr_accessor :sections, :on_save, :interactor, :controller

    def initialize(opts = {})
      self.sections = []
      if opts[:sections]
        opts[:sections].each do |section|
          section[:form] = self
          klass = section[:options] ? SelectionSection : Section
          self.sections << klass.new(section)
        end
      end
      self.interactor = opts[:interactor]
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


    def row_for_index(index)
      self.visible_sections[index.section].visible_rows[index.row]
    end

    def next_row(row)
      index = index_for_row(row)
      row_index = index.row
      section_index = index.section

      if !(next_row = self.visible_sections[section_index].visible_rows[row_index + 1]).nil?
        next_row
      elsif !(next_section = self.visible_sections[section_index + 1]).nil?
        next_section.visible_rows.first
      end
    end

    def previous_row(row)
      index = index_for_row(row)
      row_index = index.row
      section_index = index.section

      if row_index > 0
        self.visible_sections[section_index].visible_rows[row_index - 1]
      elsif section_index > 0
        self.visible_sections[section_index - 1].visible_rows.last
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

    def update
      self.sections.map(&:rows).flatten.each do |row|
        row.evaluate_hidden
        row.evaluate_disabled
      end
    end

    def index_for_row(row)
      section_index = visible_sections.index(row.section)
      row_index = row.section.visible_rows.index(row)
      NSIndexPath.indexPathForRow(row_index, inSection:section_index)
    end

    def insert_row(row, index)
      section = sections[index.section]
      row[:section] = section
      row = Row.new(row)
      section.rows.insert(index.row, row)

      self.interactor.insert_row(row, index) if self.interactor
    end

    def show_row(row, index)
      self.interactor.insert_row(row, index) if self.interactor
    end

    def remove_row(row, index)
      self.interactor.remove_row(row, index) if self.interactor
      row.section.rows.delete(row)
    end

    def hide_row(row, index)
      self.interactor.remove_row(row, index) if self.interactor
    end

    def insert_section(section, index)
      section[:form] = self
      section = Section.new(section)
      sections.insert(index, section)

      self.interactor.insert_section(section, index) if self.interactor
    end

    def remove_section(section)
      self.interactor.remove_section(section, sections.index(section)) if self.interactor
      sections.delete(section)
    end

    def move_row(from_index, to_index)
      from_section = sections[from_index.section]
      to_section = sections[to_index.section]
      from_section.rows[from_index.row], to_section.rows[to_index.row] = to_section.rows[to_index.row], from_section.rows[from_index.row]

      self.interactor.move_row(from_index, to_index) if self.interactor
    end

    def move_section(from_index, to_index)
      sections[from_index], sections[to_index] = sections[to_index], sections[from_index]

      self.interactor.move_section(from_index, to_index) if self.interactor
    end
  end
end
