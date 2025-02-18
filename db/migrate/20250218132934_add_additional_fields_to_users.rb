class AddAdditionalFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :birth_date, :date
    add_column :users, :phone_number, :string
    add_column :users, :gender, :string
    add_column :users, :sns_link, :string
  end
end
