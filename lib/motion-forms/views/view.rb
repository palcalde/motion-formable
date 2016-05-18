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
    return self if self.is_a?(UITableViewCell)
    if self.superview && cell = self.superview.parent_cell
      return cell
    end
    nil
  end
end
