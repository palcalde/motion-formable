class OtherCellsController < UITableViewController
  include MotionListable::TableHelper
  include MotionFormable::FormHelper

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
    @form ||= MotionFormable::Form.new({
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
                class: MotionFormable::SwitchCell,
              }
            },
            {
              fields: [{ key: :check, value: true }],
              title: 'Check',
              cell: {
                class: MotionFormable::CheckCell,
              }
            },
            {
              fields: [{ key: :step, value: 5 }],
              title: 'Step counter',
              cell: {
                type: UITableViewCellStyleValue1,
                class: MotionFormable::StepperCell,
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
                class: MotionFormable::SegmentedCell,
              }
            },
            {
              fields: [{ key: :slider, value: 15 }],
              title: 'Slider',
              cell: {
                min: 5,
                max: 20,
                steps: 3,
                class: MotionFormable::SliderCell,
              }
            },
          ]
        },
      ]
    })
  end
end
