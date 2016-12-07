module MotionFormable
  class Section
    attr_accessor :rows,
                  :key,
                  :form,
                  :table_options,
                  :hidden

    def hidden?
      !!@hidden
    end

    def initialize(opts = {})
      self.key = opts[:key]
      self.form = opts[:form]
      self.rows = []
      if opts[:rows]
        opts[:rows].each do |row|
          row[:section] = self
          self.rows << Row.new(row)
        end
      end
      self.table_options = opts[:table_options] || {}
    end

    def visible_rows
      self.rows.reject(&:hidden?)
    end

    def move_row(from, to)
      rows[from], rows[to] = rows[to], rows[from]
    end

    def errors
      rows.map(&:errors)
    end

    def to_hash
      hashes = rows.map(&:to_hash)
      hash = HashHelper.merge_hashes(hashes)
      key ? { key => hash } : hash
    end

    def to_field_hash
      hashes = rows.map(&:to_field_hash)
      hash = HashHelper.merge_hashes(hashes)
      key ? { key => hash } : hash
    end

    def to_row_hash
      hashes = rows.map(&:to_row_hash)
      hash = HashHelper.merge_hashes(hashes)
      key ? { key => hash } : hash
    end

    def to_table_hash
      { cells: visible_rows.map(&:cell) }.merge(self.table_options)
    end
  end
end
