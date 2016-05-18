describe 'Form' do

  it "entities from an entity set can be displayed in several sections" do
    form = MotionForms::Form.new({
      controller: self,
      sections: [
        {
          key: :users,
          rows: [
            {
              fields: [
                { key: :id, value: 1 },
                { key: :email, value: 'foo1@example.com' },
                { key: :name, value: 'Mark' },
                { key: :surname, value: 'V' },
              ]
            },
          ]
        },
        {
          key: :users,
          rows: [
            {
              fields: [
                { key: :id, value: 2 },
                { key: :email, value: 'foo2@example.com' },
                { key: :name, value: 'Mark' },
                { key: :surname, value: 'V' },
              ]
            }
          ]
        }
      ]
    })

    form.to_hash.should == {
      users: [
        {
          id: 1,
          email: 'foo1@example.com',
          name: 'Mark',
          surname: 'V',
        },
        {
          id: 2,
          email: 'foo2@example.com',
          name: 'Mark',
          surname: 'V',
        }
      ]
    }
  end

  it "section can contain an entity" do
    form = MotionForms::Form.new({
      controller: self,
      sections: [
        {
          key: :user,
          rows: [
            {
              fields: [
                { key: :id, value: 1 },
                { key: :email, value: 'foo1@example.com' },
                { key: :name, value: 'Mark' },
                { key: :surname, value: 'V' },
              ]
            },
          ]
        }
      ]
    })

    form.to_hash.should == {
      user: {
        id: 1,
        email: 'foo1@example.com',
        name: 'Mark',
        surname: 'V',
      }
    }
  end

  it "section can contain multiple entities, edited in subforms" do

    subform = {
      controller: self,
      sections: [
        {
          rows: [
            {
              fields: [
                { key: :id, value: 1 },
                { key: :email, value: 'foo1@example.com' },
                { key: :name, value: 'Mark' },
                { key: :surname, value: 'V' },
              ]
            }
          ]
        }
      ]
    }

    subform2 = {
      controller: self,
      sections: [
        {
          rows: [
            {
              fields: [
                { key: :id, value: 2 },
                { key: :email, value: 'foo2@example.com' },
                { key: :name, value: 'Mark' },
                { key: :surname, value: 'V' },
              ]
            }
          ]
        }
      ]
    }

    form = MotionForms::Form.new({
      controller: self,
      sections: [
        {
          rows: [
            { key: :users, subform: subform },
            { key: :users, subform: subform2 },
          ]
        }
      ]
    })

    form.to_hash.should == {
      users: [
        {
          id: 1,
          email: 'foo1@example.com',
          name: 'Mark',
          surname: 'V',
        },
        {
          id: 2,
          email: 'foo2@example.com',
          name: 'Mark',
          surname: 'V',
        }
      ]
    }
  end

  it "can fetch row by index" do
    form = MotionForms::Form.new({
      sections: [
        {
          rows: [
            { title: 'foo' },
            { title: 'bar' },
          ]
        }
      ]
    })

    form.sections.first.rows[1].should == form.row_for_index([0,1].to_index)
  end

  it "can fetch index by row" do
    form = MotionForms::Form.new({
      sections: [
        {
          rows: [
            { title: 'foo' },
            { title: 'bar' },
          ]
        }
      ]
    })

    NSIndexPath.indexPathForRow(1, inSection:0).should == form.index_for_row(form.sections.first.rows[1])
  end

  it "can fetch next and previous row" do
    form = MotionForms::Form.new({
      sections: [
        {
          rows: [
            { title: 'foo' },
            { title: 'bar' },
          ]
        },
        {
          rows: [
            { title: 'foo' },
            { title: 'bar' },
          ]
        }
      ]
    })

    form.next_row(form.sections[0].rows[0]).should == form.sections[0].rows[1]
    form.next_row(form.sections[0].rows[1]).should == form.sections[1].rows[0]
    form.next_row(form.sections[1].rows[1]).should == nil

    form.previous_row(form.sections[0].rows[0]).should == nil
    form.previous_row(form.sections[0].rows[1]).should == form.sections[0].rows[0]
    form.previous_row(form.sections[1].rows[0]).should == form.sections[0].rows[1]
  end

  it "can insert, delete and move rows" do
    form = MotionForms::Form.new({
      sections: [
        {
          rows: [
            { title: 'foo' },
            { title: 'bar' },
          ]
        },
        {
          rows: [
            { title: 'foo' },
            { title: 'bar' },
          ]
        }
      ]
    })

    new_row_hash = { title: 'new row' }
    form.insert_row(new_row_hash, [0,1].to_index)
    form.sections[0].rows.count.should == 3
    new_row = form.row_for_index([0,1].to_index)
    new_row.title.should == 'new row'

    form.move_row([0,1].to_index, [0,0].to_index)
    form.row_for_index([0,0].to_index).should == new_row

    form.remove_row(new_row)
    form.sections[0].rows.count.should == 2
  end

  it "can insert, delete and move sections" do
    form = MotionForms::Form.new({
      sections: [
        {
          rows: [
            { title: 'foo' },
            { title: 'bar' },
          ]
        },
        {
          rows: [
            { title: 'foo' },
            { title: 'bar' },
          ]
        }
      ]
    })

    new_section_hash = { rows: [{ title: 'new section' }] }

    form.insert_section(new_section_hash, 1)
    form.sections[1].rows.first.title.should == 'new section'

    new_section = form.sections[1]

    form.move_section(1, 0)
    form.sections.first.should == new_section

    form.remove_section(new_section)
    form.sections.count.should == 2
  end

end
