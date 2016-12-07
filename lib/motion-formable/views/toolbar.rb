#
# A toolbar shown above the keyboard, picker view, or other custom input view.
# Shows two arrows used to navigate to the next or previous form field or and
# button to close the input view.
#
# Here shown with a picker view:
#
# ┌──────────────────────┐
# │⟨ ⟩              Done │
# ├──────────────────────┤
# │       Option 1       │
# │       Option 2       │
# ├──────────────────────┤
# │       Option 3       │
# ├──────────────────────┤
# │       Option 4       │
# │       Option 5       │
# └──────────────────────┘
#
module MotionFormable
  class Toolbar < UIToolbar
    attr_accessor :previous_button, :next_button, :done_button

    def initWithFrame(frame)
      super([[0, 0], [UIScreen.mainScreen.bounds.size.width, 44.0]])
      self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                              UIViewAutoresizingFlexibleRightMargin |
                              UIViewAutoresizingFlexibleWidth
      self.previous_button = button_with_item(105)
      self.next_button = button_with_item(106)
      self.done_button = button_with_item(UIBarButtonSystemItemDone)
      flexible_space = button_with_item(UIBarButtonSystemItemFlexibleSpace)
      fixed_space = button_with_item(UIBarButtonSystemItemFixedSpace)
      self.items = [previous_button, fixed_space, next_button, flexible_space, done_button]
      self
    end

    def button_with_item(item)
      UIBarButtonItem.alloc.initWithBarButtonSystemItem(item, target:nil, action:nil)
    end
  end
end
