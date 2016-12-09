class SubformViewController < UITableViewController
  include MotionListable::TableHelper
  include MotionFormable::FormHelper

  attr_accessor :form

  def viewDidLoad
    self.tableView.delegate = self
    self.tableView.dataSource = self
  end
end
