class Array
  def to_index
    NSIndexPath.indexPathForRow(self[1], inSection:self[0])
  end
end
