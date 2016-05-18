describe 'Cell' do
  describe OtherCellsController do
    tests OtherCellsController

    it "can show a switch cell" do
      index = NSIndexPath.indexPathForRow(0, inSection:0)
      row = self.controller.form.row_for_index(index)
      cell = self.controller.tableView.cellForRowAtIndexPath(index)
      cell.class.should == MotionForms::SwitchCell
      cell.accessoryView.class.should == UISwitch
      cell.editingAccessoryView.should == cell.accessoryView
      orig_value = row.fields.first.value
      switch = cell.accessoryView
      switch.setOn(!switch.on?, animated:false)
      switch.sendActionsForControlEvents(UIControlEventValueChanged)
      orig_value.should == !row.fields.first.value
    end

    it "can show a check cell" do
      index = NSIndexPath.indexPathForRow(1, inSection:0)
      row = self.controller.form.row_for_index(index)
      cell = self.controller.tableView.cellForRowAtIndexPath(index)
      cell.class.should == MotionForms::CheckCell
      cell.accessoryType.should == UITableViewCellAccessoryCheckmark
      cell.accessoryType.should == cell.editingAccessoryType
      orig_value = row.fields.first.value
      tap(cell)
      orig_value.should == !row.fields.first.value
      orig_value = row.fields.first.value
      cell.accessoryType.should == UITableViewCellAccessoryNone
    end

    it "can show a stepper cell" do
      index = NSIndexPath.indexPathForRow(2, inSection:0)
      row = self.controller.form.row_for_index(index)
      cell = self.controller.tableView.cellForRowAtIndexPath(index)
      cell.class.should == MotionForms::StepperCell
      orig_value = row.fields.first.value
      cell.current_step_value.text.should == orig_value.to_s
      cell.step_control.value = orig_value + 1
      cell.step_control.sendActionsForControlEvents(UIControlEventValueChanged)
      row.fields.first.value.should == orig_value + 1
      cell.current_step_value.text.should == (orig_value + 1).to_s
    end

    it "can show a segmented cell" do
      index = NSIndexPath.indexPathForRow(3, inSection:0)
      row = self.controller.form.row_for_index(index)
      cell = self.controller.tableView.cellForRowAtIndexPath(index)
      cell.class.should == MotionForms::SegmentedCell
      segmented_control = cell.segmented_control
      segmented_control.selectedSegmentIndex = 0
      segmented_control.sendActionsForControlEvents(UIControlEventValueChanged)
      row.fields.first.value.should == cell.options[0][:value]
      segmented_control.selectedSegmentIndex = 1
      segmented_control.sendActionsForControlEvents(UIControlEventValueChanged)
      row.fields.first.value.should == cell.options[1][:value]
      segmented_control.selectedSegmentIndex = 2
      segmented_control.sendActionsForControlEvents(UIControlEventValueChanged)
      row.fields.first.value.should == cell.options[2][:value]
    end

    it "can show a slider cell" do
      index = NSIndexPath.indexPathForRow(4, inSection:0)
      row = self.controller.form.row_for_index(index)
      cell = self.controller.tableView.cellForRowAtIndexPath(index)
      cell.class.should == MotionForms::SliderCell
      cell.slider.value = 6
      cell.slider.sendActionsForControlEvents(UIControlEventValueChanged)
      row.fields.first.value.should == 5
      cell.slider.value = 19
      cell.slider.sendActionsForControlEvents(UIControlEventValueChanged)
      row.fields.first.value.should == 20
      cell.slider.value = 0
      cell.slider.sendActionsForControlEvents(UIControlEventValueChanged)
      row.fields.first.value.should == 5
      cell.slider.value = 40
      cell.slider.sendActionsForControlEvents(UIControlEventValueChanged)
      row.fields.first.value.should == 20
    end

  end

  describe TextFieldsController do
    tests TextFieldsController

    it "can show a textfield cell" do
      index = NSIndexPath.indexPathForRow(0, inSection:0)
      row = self.controller.form.row_for_index(index)
      cell = self.controller.tableView.cellForRowAtIndexPath(index)
      cell.class.should == MotionForms::TextFieldCell
      cell.text_field.text = "foo"
      cell.text_field.sendActionsForControlEvents(UIControlEventEditingChanged)
      row.fields.first.value.should == "foo"
    end

    it "can show a textview cell" do
      index = NSIndexPath.indexPathForRow(1, inSection:0)
      row = self.controller.form.row_for_index(index)
      cell = self.controller.tableView.cellForRowAtIndexPath(index)
      cell.class.should == MotionForms::TextViewCell
      cell.text_view.text = "foo"
      cell.text_view.delegate.textViewDidChange(cell.text_view)
      row.fields.first.value.should == "foo"
    end
  end

  # TODO: Test cells in SelectorsController
end
