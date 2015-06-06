class RemoveNumPlayersAndParticipantFromQuests < ActiveRecord::Migration
  def change
    remove_column :quests, :num_players, :integer
    remove_column :quests, :participant, :boolean
  end
end
