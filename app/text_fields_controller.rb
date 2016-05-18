class TextFieldsController < UITableViewController
  include MotionIOSTable::TableHelper
  include MotionForms::FormHelper

  def viewDidLoad
    self.tableView.delegate = self
    self.tableView.dataSource = self

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle('Validate',
      style:UIBarButtonItemStylePlain, target:self, action: :validate_form)
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
          rows: [
            {
              title: 'Email:',
              fields: [{ key: :email, value: 'foo@example.com' }],
              type: :email,
              cell: {
                class: MotionForms::TextFieldCell,
              }
            },
            {
              title: 'Notes',
              fields: [{ key: :email }],
              type: :email,
              cell: {
                class: MotionForms::TextViewCell,
              }
            }
          ]
        }
      ]
    })
  end
end
