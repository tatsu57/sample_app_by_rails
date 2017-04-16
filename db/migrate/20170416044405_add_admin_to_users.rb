class AddAdminToUsers < ActiveRecord::Migration
  def change
    # defaultをfalseにしておくことで、ユーザーが作成された時、一般ユーザーになる
    add_column :users, :admin, :boolean, default: false
  end
end
