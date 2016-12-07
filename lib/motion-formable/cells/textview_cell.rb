#
# A cell with a label (optional) and a textview, with 110px height
#
# ┌────────────────────────┐
# │ Label TextView         │
# │                        │
# │                        │
# │                        │
# └────────────────────────┘
#
# /images/cells/textview_cell.png
#
module MotionFormable
  class TextViewCell < BaseCell
    attr_accessor :text_label,
                  :text_view,
                  :dynamic_constraints

    def on_create
      self.text_label = UILabel.new
      self.text_label.translatesAutoresizingMaskIntoConstraints = false
      self.text_view = UITextView.new
      self.text_view.translatesAutoresizingMaskIntoConstraints = false
      self.contentView.addSubview(self.text_label)
      self.contentView.addSubview(self.text_view)
      views = { 'label' => self.text_label, 'textView' => self.text_view }
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[label]", options:0, metrics:0, views:views))
      self.contentView.addConstraint(NSLayoutConstraint.constraintWithItem(self.text_view,
         attribute:NSLayoutAttributeTop, relatedBy:NSLayoutRelationEqual,
         toItem:self.contentView, attribute:NSLayoutAttributeTop, multiplier:1, constant:0))
      self.contentView.addConstraint(NSLayoutConstraint.constraintWithItem(self.text_view,
        attribute:NSLayoutAttributeBottom, relatedBy:NSLayoutRelationEqual,
        toItem:self.contentView, attribute:NSLayoutAttributeBottom, multiplier:1, constant:0))
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[textView]-0-|", options:0, metrics:0, views:views))
      self.row.cell[:height] = 110
    end

    def updateConstraints
      if self.dynamic_constraints
        self.contentView.removeConstraints(self.dynamic_constraints)
      end

      views = { 'label' => self.text_label, 'textView' => self.text_view }
      constraints_block = proc do |format|
        NSLayoutConstraint.constraintsWithVisualFormat(format, options:0, metrics:nil, views:views)
      end

      self.dynamic_constraints = []
      if !self.text_label.text || self.text_label.text == ''
        self.dynamic_constraints.push(*constraints_block.call("H:|-[textView]-|"))
      else
        self.dynamic_constraints.push(*constraints_block.call("H:|-[label]-[textView]-|"))
      end
      self.contentView.addConstraints(self.dynamic_constraints)
      super
    end

    def update!
      self.text_view.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
      # self.text_view.placeHolderLabel.font = self.text_view.font
      self.text_view.delegate = self
      self.text_view.keyboardType = UIKeyboardTypeDefault
      self.text_view.text = fields.first.value
      self.text_view.editable = !self.row.disabled?
      self.text_view.textColor = self.row.disabled? ? UIColor.grayColor : UIColor.blackColor
      self.text_label.text = self.row.title if self.row.title
      setNeedsUpdateConstraints
    end

    def textViewDidBeginEditing(textView)
      highlight
    end

    def textViewDidEndEditing(textView)
      text = self.text_view.text.empty? ? nil : self.text_view.text
      self.fields.first.value = text
      unhighlight
    end

    def textViewDidChange(textView)
      text = self.text_view.text.empty? ? nil : self.text_view.text
      self.fields.first.value = text
    end

    def textFieldShouldClear(textField)
      self.row.fields.first.value = nil
      true
    end

    def canBecomeFirstResponder
      !self.row.disabled?
    end

    def becomeFirstResponder
      self.text_view.becomeFirstResponder
    end

    def highlight
      self.text_label.textColor = self.tintColor
    end

    def unhighlight
      update!
    end
  end
end
