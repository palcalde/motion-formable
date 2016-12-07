class UIView
  def findFirstResponder
    return self if self.isFirstResponder
    self.subviews.each do |subview|
      firstResponder = subview.findFirstResponder
      return firstResponder if firstResponder
    end
    nil
  end

  def parent_cell
    if self.is_a?(UITableViewCell)
      self
    elsif self.superview && self.superview.parent_cell
      self.superview.parent_cell
    end
  end
end
