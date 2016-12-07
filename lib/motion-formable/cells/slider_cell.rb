#
# A cell with a slider to select numerical values
#
# ┌───────────────────────────────┐
# │ Title                         │
# │ ───────────────────●───────── │
# └───────────────────────────────┘
#
# /images/cells/slider_cell.gif
#
module MotionFormable
  class SliderCell < BaseCell
    attr_accessor :slider, :text_label, :steps, :min, :max

    def on_create
      self.text_label = UILabel.new
      self.text_label.translatesAutoresizingMaskIntoConstraints = false
      self.slider = UISlider.new
      self.slider.translatesAutoresizingMaskIntoConstraints = false
      self.steps = 0
      self.slider.addTarget(self, action:"valueChanged:", forControlEvents:UIControlEventValueChanged)
      self.contentView.addSubview(self.slider)
      self.contentView.addSubview(self.text_label)
      self.selectionStyle = UITableViewCellSelectionStyleNone

      self.contentView.addConstraint(NSLayoutConstraint.constraintWithItem(self.text_label,
        attribute:NSLayoutAttributeTop, relatedBy:NSLayoutRelationEqual,
        toItem:self.contentView, attribute:NSLayoutAttributeTop, multiplier:1, constant:10))

      self.contentView.addConstraint(NSLayoutConstraint.constraintWithItem(self.slider,
        attribute:NSLayoutAttributeTop, relatedBy:NSLayoutRelationEqual,
        toItem:self.contentView, attribute:NSLayoutAttributeTop, multiplier:1, constant:44))

      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[text_label]-|",
        options:0, metrics:0, views:{ "text_label" => self.text_label }))
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[slider]-|",
        options:0, metrics:0, views:{ "slider" => self.slider }))
      self.row.cell[:height] = 88
    end

    def update!
      self.text_label.text = self.row.title if self.row.title
      self.slider.minimumValue = self.min
      self.slider.maximumValue = self.max
      self.slider.value = fields.first.value
      self.slider.enabled = !self.row.disabled?
    end

    def valueChanged(slider)
      if self.steps != 0
        value = self.slider.value
        min = self.slider.minimumValue
        max = self.slider.maximumValue
        self.slider.value = (((value - min).to_f / (max - min) * steps).round * (max - min).to_f / steps + min)
      end
      fields.first.value = self.slider.value
    end
  end
end
