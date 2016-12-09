class ViewController < UITableViewController
  include MotionListable::TableHelper
  # include MotionFormable::FormHelper

  def viewDidLoad
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.title = 'Examples'

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle('Validate',
      style:UIBarButtonItemStylePlain, target:self, action: :validate_form)
  end

  def data_source
    @data_source ||= {
      sections: [
        {
          header_title: 'Real Examples',
          cells: [
            {
              textLabel: { text: 'iOS Calendar Event Form' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc { }
            }
          ]
        },
        {
          header_title: 'This form is actually an example',
          footer_title: 'main_view_controller.rb, Select an option to view another example',
          cells: [
            {
              textLabel: { text: 'Text Fields' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc { push_controller(TextFieldsController) }
            },
            {
              textLabel: { text: 'Selectors' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc { push_controller(SelectorsController) }
            },
            {
              textLabel: { text: 'Date & Time' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc { push_controller(DateTimeController) }
            },
            {
              textLabel: { text: 'Other Rows' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc { push_controller(OtherCellsController) }
            }
          ]
        },
        {
          header_title: 'Multivalued Example',
          cells: [
            {
              textLabel: { text: 'Multivalued Sections' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc {}
            },
            {
              textLabel: { text: 'Multivalued Only Reorder' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc {}
            },
            {
              textLabel: { text: 'Multivalued Only Insert' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc {}
            },
            {
              textLabel: { text: 'Multivalued Only Delete' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc {}
            }
          ]
        },
        {
          header_title: 'UI Customization',
          cells: [
            {
              textLabel: { text: 'UI Customization' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc {}
            }
          ]
        },
        {
          header_title: 'Custom Rows',
          cells: [
            {
              textLabel: { text: 'Custom Rows' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc {}
            }
          ]
        },
        {
          header_title: 'Accessory View',
          cells: [
            {
              textLabel: { text: 'Accessory Views' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc {}
            }
          ]
        },
        {
          header_title: 'Validation Examples',
          cells: [
            {
              textLabel: { text: 'Validation Examples' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc {}
            }
          ]
        },
        {
          header_title: 'Using Predicates',
          cells: [
            {
              textLabel: { text: 'Very basic predicates' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc {}
            },
            {
              textLabel: { text: 'Blog Example Hide predicates' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc {}
            },
            {
              textLabel: { text: 'Another example' },
              accessoryType: UITableViewCellAccessoryDisclosureIndicator,
              on_select: proc {}
            }
          ]
        }
      ]
    }
  end

  def push_controller(klass)
    controller = klass.alloc.initWithStyle(UITableViewStyleGrouped)
    self.navigationController.pushViewController(controller, animated:true)
  end
end
