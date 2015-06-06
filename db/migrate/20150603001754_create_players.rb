class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name, null: false
      t.references :game, index: true

      t.timestamps
    end
    add_index :players, [:name, :game_id], unique: true
  end
end
