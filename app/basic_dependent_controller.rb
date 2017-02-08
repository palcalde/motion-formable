class BasicDependentController < UITableViewController
  include MotionListable::TableHelper
  include MotionFormable::FormHelper

  def viewDidLoad
    self.tableView.delegate = self
    self.tableView.dataSource = self
  end

  def validate_form
    p form.to_field_hash
    p form.errors
    p form.validate!
  end

  def form
    @form ||= MotionFormable::Form.new({
      controller: self,
      sections: [
        {
          table_options: {
            header_title: 'A section'
          },
          rows: [
            {
              fields: [{ key: :switch, value: false }],
              tag: 'first',
              title: 'Switch',
              cell: {
                class: MotionFormable::SwitchCell,
              }
            },
            {
              fields: [{ key: :name }],
              # hidden: proc { |form| form.row_with_tag('first').value != true },
              disabled: proc { |form| form.row_with_tag('first').value != true },
              tag: 'second',
              title: "hello",
              cell: {
                class: MotionFormable::TextFieldCell
              }
            },
          ]
        },
      ]
    })
  end
end
