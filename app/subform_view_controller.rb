class SubformViewController < UITableViewController
  include MotionIOSTable::TableHelper
  include MotionForms::FormHelper

  attr_accessor :form

  def viewDidLoad
    self.tableView.delegate = self
    self.tableView.dataSource = self
  end
end
