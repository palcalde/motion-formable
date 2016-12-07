class SelectorsController < UITableViewController
  include MotionIOSTable::TableHelper
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
            header_title: 'Selectors'
          },
          rows: [
            {
              fields: [{ key: :country, value: 'Spain' }],
              subform: {
                controller: self,
                sections: [
                  {
                    options: [
                      { title: 'Red', key: :red, value: true },
                      { title: 'Blue', key: :blue, value: false },
                      { title: 'Green', key: :green, value: true }
                    ],
                    multiselection: true
                  }
                ]
              },
              subform_controller: SubformViewController,
              cell: {
                type: UITableViewCellStyleValue1,
                accessoryType: UITableViewCellAccessoryDisclosureIndicator,
                editingAccessoryType: UITableViewCellAccessoryDisclosureIndicator,
                textLabel: { text: 'Push' },
                on_display: proc do |_,cell,_|
                  cell.detailTextLabel.text = cell.row.subform.to_hash.values.join(',')
                  p cell.row.subform.to_hash
                end
              }
            },
            {
              fields: [{ key: :sheet, value: 1 }],
              cell: {
                class: MotionFormable::SheetCell,
                type: UITableViewCellStyleValue1,
                textLabel: { text: 'Sheet' },
                options: [
                  { title: 'Option 1', value: 1 },
                  { title: 'Option 2', value: 2 },
                  { title: 'Option 3', value: 3 },
                  { title: 'Option 4', value: 4 },
                  { title: 'Option 5', value: 5 },
                ],
              }
            },
            {
              fields: [{ key: :alert, value: 1 }],
              cell: {
                class: MotionFormable::AlertCell,
                type: UITableViewCellStyleValue1,
                textLabel: { text: 'Alert View' },
                options: [
                  { title: 'Option 1', value: 1 },
                  # { title: 'Option 2', value: 2 },
                  # { title: 'Option 3', value: 3 },
                  # { title: 'Option 4', value: 4 },
                  # { title: 'Option 5', value: 5 },
                ],
              }
            },
            {
              fields: [{ key: :picker_input, value: 1 }],
              cell: {
                class: MotionFormable::PickerInputCell,
                type: UITableViewCellStyleValue1,
                textLabel: { text: 'Picker View' },
                options: [
                  { title: 'Option 1', value: 1 },
                  { title: 'Option 2', value: 2 },
                  { title: 'Option 3', value: 3 },
                  { title: 'Option 4', value: 4 },
                  { title: 'Option 5', value: 5 },
                ],
              }
            },
          ]
        },
        {
          table_options: {
            header_title: 'Fixed Controls'
          },
          rows: [
            {
              fields: [{ key: :picker, value: 1 }],
              cell: {
                class: MotionFormable::PickerCell,
                options: [
                  { title: 'Option 1', value: 1 },
                  { title: 'Option 2', value: 2 },
                  { title: 'Option 3', value: 3 },
                  { title: 'Option 4', value: 4 },
                  { title: 'Option 5', value: 5 },
                ],
              }
            },
          ]
        }
      ]
    })
  end
end
