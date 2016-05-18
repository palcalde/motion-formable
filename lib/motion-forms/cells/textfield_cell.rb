#
# A cell with an image (optional), a label and a textfield laid horizontally
#
# ┌────────────────────────┐
# │ ⬜︎  Label TextField     │
# └────────────────────────┘
#
# /images/cells/textfield_cell.png
#
module MotionForms
  class TextFieldCell < BaseCell
    attr_accessor :text_label,
                  :text_field,
                  :textfield_type,
                  :dynamic_constraints

    def on_create
      self.text_label = UILabel.new
      self.text_label.translatesAutoresizingMaskIntoConstraints = false
      self.text_label.setContentHuggingPriority(500, forAxis:UILayoutConstraintAxisHorizontal)
      self.text_label.setContentCompressionResistancePriority(1000, forAxis:UILayoutConstraintAxisHorizontal)
      self.text_field = UITextField.new
      self.text_field.translatesAutoresizingMaskIntoConstraints = false
      self.selectionStyle = UITableViewCellSelectionStyleNone
      self.contentView.addSubview(self.text_label)
      self.contentView.addSubview(self.text_field)
      self.contentView.addConstraints(self.layoutConstraints)
      self.text_field.addTarget(self, action: 'textFieldDidChange:', forControlEvents:UIControlEventEditingChanged)
      self.text_field.text = fields.first.value
    end

    def layoutConstraints
      # Add Constraints
      constraints = []
      views = { 'textField' => text_field, 'textLabel' => text_label }
      constraints.concat(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(>=11)-[textField]-(>=11)-|",
        options:NSLayoutFormatAlignAllBaseline, metrics:nil, views:views))
      constraints.concat(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(>=11)-[textLabel]-(>=11)-|",
        options:NSLayoutFormatAlignAllBaseline, metrics:nil, views:views))
      constraints
    end

    def updateConstraints
      if self.dynamic_constraints
        self.contentView.removeConstraints(self.dynamic_constraints)
      end

      views = { 'label' => self.text_label, 'textField' => self.text_field, 'image' => self.imageView }
      constraints_block = proc do |format|
        NSLayoutConstraint.constraintsWithVisualFormat(format, options:0, metrics:nil, views:views)
      end

      if self.imageView.image
        if self.text_label.text.length > 0
          self.dynamic_constraints = constraints_block.call("H:[image]-[label]-[textField]-|")
        else
          self.dynamic_constraints = constraints_block.call("H:[image]-[textField]-|")
        end
      else
        if self.text_label.text.length > 0
          self.dynamic_constraints = constraints_block.call("H:|-[label]-[textField]-|")
        else
          self.dynamic_constraints = constraints_block.call("H:|-[textField]-|")
        end
      end

      self.dynamic_constraints << NSLayoutConstraint.constraintWithItem(self.text_field,
        attribute: NSLayoutAttributeWidth,
        relatedBy: NSLayoutRelationGreaterThanOrEqual,
        toItem: self.contentView,
        attribute: NSLayoutAttributeWidth,
        multiplier: 0.3,
        constant: 0.0)

      self.contentView.addConstraints(self.dynamic_constraints)
      super
    end

    def update!
      self.text_field.delegate = self
      self.text_field.clearButtonMode = UITextFieldViewModeWhileEditing

      case textfield_type
      when :text
       self.text_field.autocorrectionType = UITextAutocorrectionTypeDefault
       self.text_field.autocapitalizationType = UITextAutocapitalizationTypeSentences
       self.text_field.keyboardType = UIKeyboardTypeDefault
      when :name
        self.text_field.autocorrectionType = UITextAutocorrectionTypeNo
        self.text_field.autocapitalizationType = UITextAutocapitalizationTypeWords
        self.text_field.keyboardType = UIKeyboardTypeDefault
      when :email
        self.text_field.keyboardType = UIKeyboardTypeEmailAddress
        self.text_field.autocorrectionType = UITextAutocorrectionTypeNo
        self.text_field.autocapitalizationType = UITextAutocapitalizationTypeNone
      when :number
        self.text_field.keyboardType = UIKeyboardTypeNumbersAndPunctuation
        self.text_field.autocorrectionType = UITextAutocorrectionTypeNo
        self.text_field.autocapitalizationType = UITextAutocapitalizationTypeNone
      when :integer
        self.text_field.keyboardType = UIKeyboardTypeNumberPad
      when :decimal
        self.text_field.keyboardType = UIKeyboardTypeDecimalPad
      when :password
        self.text_field.autocorrectionType = UITextAutocorrectionTypeNo
        self.text_field.autocapitalizationType = UITextAutocapitalizationTypeNone
        self.text_field.keyboardType = UIKeyboardTypeASCIICapable
        self.text_field.secureTextEntry = true
      when :phone
        self.text_field.keyboardType = UIKeyboardTypePhonePad
      when :url
        self.text_field.autocorrectionType = UITextAutocorrectionTypeNo
        self.text_field.autocapitalizationType = UITextAutocapitalizationTypeNone
        self.text_field.keyboardType = UIKeyboardTypeURL
      when :twitter
        self.text_field.keyboardType = UIKeyboardTypeTwitter
        self.text_field.autocorrectionType = UITextAutocorrectionTypeNo
        self.text_field.autocapitalizationType = UITextAutocapitalizationTypeNone
      when :account
        self.text_field.keyboardType = UIKeyboardTypeASCIICapable
        self.text_field.autocorrectionType = UITextAutocorrectionTypeNo
        self.text_field.autocapitalizationType = UITextAutocapitalizationTypeNone
      when :zipcode
        self.text_field.autocorrectionType = UITextAutocorrectionTypeNo
        self.text_field.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters
        self.text_field.keyboardType = UIKeyboardTypeDefault
      end

      self.text_label.text = self.row.title if self.row.title
      self.text_field.enabled = !self.row.disabled?
      self.text_field.textColor = self.row.disabled? ? UIColor.grayColor : UIColor.blackColor
      self.text_field.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)

      setNeedsUpdateConstraints
    end

    def textFieldDidBeginEditing(textField)
      highlight
    end

    def textFieldDidEndEditing(textField)
      unhighlight
    end

    def canBecomeFirstResponder
      !self.row.disabled?
    end

    def becomeFirstResponder
      self.text_field.becomeFirstResponder
    end

    def highlight
      self.text_label.textColor = self.tintColor
    end

    def unhighlight
      update!
    end

    def textFieldDidChange(textField)
      if self.text_field.text.length > 0
        self.fields.first.value = self.text_field.text
      else
        self.fields.first.value = nil
      end
    end
  end
end
