class OtherCellsController < UITableViewController
  include MotionIOSTable::TableHelper
  include MotionForms::FormHelper

  def viewDidLoad
    self.tableView.delegate = self
    self.tableView.dataSource = self

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle('Validate',
      style:UIBarButtonItemStylePlain, target:self, action: :validate_form)
  end


  def viewWillAppear(animated)
    # If a cell is selected, we might be getting back from a subform or selector, so refresh the cell
    if selected = self.tableView.indexPathForSelectedRow
      self.tableView.reloadRowsAtIndexPaths([selected], withRowAnimation:UITableViewRowAnimationNone)
    end
  end

  def validate_form
    p form.fields
    p form.errors
    p form.validate!(self.tableView)
  end

  def form
    @form ||= MotionForms::Form.new({
      controller: self,
      sections: [
        {
          table_options: {
            header_title: 'Other Cells'
          },
          rows: [
            {
              fields: [{ key: :switch, value: true }],
              title: 'Switch',
              cell: {
                class: MotionForms::SwitchCell,
              }
            },
            {
              fields: [{ key: :check, value: true }],
              title: 'Check',
              cell: {
                class: MotionForms::CheckCell,
              }
            },
            {
              fields: [{ key: :step, value: 5 }],
              title: 'Step counter',
              cell: {
                type: UITableViewCellStyleValue1,
                class: MotionForms::StepperCell,
              }
            },
            {
              fields: [{ key: :segmented, value: 'def' }],
              title: 'Segmented',
              cell: {
                options: [
                  { title: 'Abc', value: 'abc' },
                  { title: 'Def', value: 'def' },
                  { title: 'Ghi', value: 'Ghi' },
                ],
                class: MotionForms::SegmentedCell,
              }
            },
            {
              fields: [{ key: :slider, value: 15 }],
              title: 'Slider',
              cell: {
                min: 5,
                max: 20,
                steps: 3,
                class: MotionForms::SliderCell,
              }
            },
          ]
        },
      ]
    })
  end
end
