class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
	  # usersテーブルのemailカラムにindexを追加する
	  # unique:trueにより、一意性が強制になる
	  add_index :users, :email, unique: true
  end
end
