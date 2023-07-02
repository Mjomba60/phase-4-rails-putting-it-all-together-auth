class ChangeTableRecipes < ActiveRecord::Migration[6.1]
  def change
    change_table :recipes do |t|
      t.rename :minutes_to_read, :minutes_to_complete
    end
  end
end
