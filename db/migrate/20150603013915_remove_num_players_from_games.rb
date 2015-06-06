class RemoveNumPlayersFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :num_players, :integer
  end
end
