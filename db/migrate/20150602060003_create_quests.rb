class CreateQuests < ActiveRecord::Migration
  def change
    create_table :quests do |t|
      t.integer :num_players
      t.integer :num_fails
      t.boolean :participant
      t.references :game, index: true

      t.timestamps
    end
  end
end
