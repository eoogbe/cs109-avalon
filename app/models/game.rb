class Game < ActiveRecord::Base
  MIN_PLAYERS = 5
  NUM_GOOD = [3, 4, 4, 5, 6, 6]
  NUM_QUEST_PLAYERS = [
    [2, 3, 2, 3, 3],
    [2, 3, 3, 3, 4],
    [2, 3, 3, 4, 4],
    [3, 4, 4, 5, 5],
    [3, 4, 4, 5, 5],
    [3, 4, 4, 5, 5]
  ]
  
  has_many :quests, ->{ order(:created_at) }
  has_many :players, ->{ order(:id) }, inverse_of: :game
  validate :num_players_valid
  accepts_nested_attributes_for :players, allow_destroy: true
  
  def next_quest_players_count
    NUM_QUEST_PLAYERS[player_idx][quests.count]
  end
  
  def num_players
    @num_players ||= players.count
  end
  
  def num_good
    @num_good ||= NUM_GOOD[player_idx]
  end
  
  def num_bad
    @num_bad ||= num_players - num_good
  end
  
  private
  
  def player_idx
    @player_idx ||= num_players - MIN_PLAYERS
  end
  
  def num_players_valid
    player_size = players.size
    if player_size < 5
      errors[:base] << "Number of players must be at least 5"
    elsif player_size > 10
      errors[:base] << "Number of players must be at most 10"
    end
  end
end
