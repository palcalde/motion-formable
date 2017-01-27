class ViewController2 < UITableViewController
  include MotionListable::TableHelper
  include MotionFormable::FormHelper

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def viewDidLoad
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.editing = true
    self.tableView.allowsSelectionDuringEditing = true

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle('Validate',
      style:UIBarButtonItemStylePlain, target:self, action: :validate_form)
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
          key: :main,
          rows: [
            # Simple row with one value
            {
              fields: [{
                key: :email,
                value: 'lol@example.com',
                validators: [{
                  block: proc { |value| value =~ VALID_EMAIL_REGEX },
                  message: "Email format is invalid"
                }]
              }],
              cell: {
                type: UITableViewCellStyleSubtitle,
                backgroundColor: UIColor.blackColor.colorWithAlphaComponent(0.03),
                detailTextLabel: {
                  textColor: UIColor.blackColor.colorWithAlphaComponent(0.5),
                }
              }
            },
            # Row with two values
            {
              fields: [{ key: :name, value: 'mark' }, { key: :surname, value: 'V' }],
              cell: {
                type: UITableViewCellStyleSubtitle,
              }
            },
            {
              fields: [{ key: :country, value: 'Spain' }],
              subform: {
                controller: self,
                sections: [
                  {
                    key: :main,
                    rows: [
                      {
                        fields: [{ key: :email, value: 'lol@example.com' }],
                        cell: {
                          type: UITableViewCellStyleSubtitle
                        }
                      }
                    ]
                  }
                ]
              },
              subform_controller: SubformViewController,
              subform_presentation: :modal,
              cell: {
                type: UITableViewCellStyleSubtitle,
              }
            },
          ]
        },

        # Users section
        {
          key: :users,
          # fields: [{ key: :id, value: 1 }],
          rows: [
            {
              fields: [{
                key: :email2,
                value: 'lol@example.com',
                validators: [{
                  block: proc { |value| value =~ VALID_EMAIL_REGEX },
                  message: "Email format is invalid"
                }]
              }],
              cell: {
                type: UITableViewCellStyleSubtitle,
              }
            }
          ]
        },
        {
          key: :users,
          fields: [{ key: :id, value: 1 }],
          rows: [
            {
              fields: [{
                key: :email,
                value: 'lol@example.com',
                validators: [{
                  block: proc { |value| value =~ VALID_EMAIL_REGEX },
                  message: "Email format is invalid"
                }]
              }],
              cell: {
                type: UITableViewCellStyleSubtitle,
              }
            }
          ]
        },
        {
          key: :colors,
          rows: [
            {
              fields: [{ key: :red, value: true }],
              cell: {
                textLabel: { text: 'Red' },
                type: UITableViewCellStyleSubtitle,
                class: MotionFormable::CheckCell,
                on_select: proc do |_,cell,_|
                  cell.fields.first.value = !cell.fields.first.value
                  cell.update!
                  cell.setSelected(false, animated: true)
                end
              }
            },
            {
              fields: [{ key: :blue, value: true }],
              cell: {
                textLabel: { text: 'Blue' },
                type: UITableViewCellStyleSubtitle,
                class: MotionFormable::CheckCell,
                on_select: proc do |_,cell,_|
                  cell.fields.first.value = !cell.fields.first.value
                  cell.update!
                  cell.setSelected(false, animated: true)
                end
              }
            },
            {
              fields: [{ key: :green, value: true }],
              cell: {
                textLabel: { text: 'Green' },
                type: UITableViewCellStyleSubtitle,
                class: MotionFormable::CheckCell,
                on_select: proc do |_,cell,_|
                  cell.fields.first.value = !cell.fields.first.value
                  cell.update!
                  cell.setSelected(false, animated: true)
                end
              }
            }
          ]
        },
        {
          key: :colors,
          options: [
            { title: 'Red', key: :red },
            { title: 'Blue', key: :blue, value: true },
            { title: 'Green', key: :green }
          ],
        },
        {
          key: :colors,
          options: [
            { title: 'Red', key: :red, value: true },
            { title: 'Blue', key: :blue, value: true },
            { title: 'Green', key: :green, value: true }
          ],
          multiselection: true
        },
        {
          rows: [
            {
              cell: {
                textlabel: { text: 'lololol' },
              }
            },
            {
              cell: {
                textlabel: { text: 'lololol' },
              }
            },
            {
              cell: {
                textlabel: { text: 'lololol' },
              }
            }
          ]
        },
        {
          can_reorder: true,
          on_row_move: proc { |from,to| p [from.row, to.row] },
          rows: [
            {
              cell: {
                textlabel: { text: '3' },
                editingStyle: UITableViewCellEditingStyleInsert,
                can_reorder: false
              }
            },
            {
              cell: {
                textlabel: { text: '1' },
                editingStyle: UITableViewCellEditingStyleDelete
              }
            },
            {
              cell: {
                textlabel: { text: '3' },
                editingStyle: UITableViewCellEditingStyleInsert,
                can_reorder: false
              }
            },
            {
              cell: {
                textlabel: { text: '2' },
                editingStyle: UITableViewCellEditingStyleDelete
              }
            },
            {
              cell: {
                textlabel: { text: '3' },
                editingStyle: UITableViewCellEditingStyleInsert,
                can_reorder: false
              }
            }
          ]
        }
      ]
    })
  end
end

# [{
#   users: [
#     {
#       id: 1
#       name: 'Mark'
#       surname: 'V'
#       email: 'mark@example.com'
#     }
#   ]
# }]

# field_set = FormFieldSet.new(key: :users)
# field_set.add_field(FormField.new(key: :name, value: 'Mark'))
# field_set.add_field(FormField.new(key: :surname, value: 'V'))
# field_set.add_field(FormField.new(key: :email, value: 'mark@example.com'))

# section with :users key and rows with :id, :name, :surname and :email keys
# FormFieldSet has multiple FormField, name spaced
# A Section with a :key acts as a FormFieldSet for the fields in its rows
