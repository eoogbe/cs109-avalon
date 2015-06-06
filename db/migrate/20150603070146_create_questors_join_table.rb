class CreateQuestorsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :quests, :players do |t|
      # t.index [:quest_id, :player_id]
      # t.index [:player_id, :quest_id]
    end
  end
end
