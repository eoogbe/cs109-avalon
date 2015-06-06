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
  accepts_nested_attributes_for :players, limit: 10, allow_destroy: true
  
  def next_quest_players_count
    NUM_QUEST_PLAYERS[player_idx][quests.count]
  end
  
  def prob_good
    @prob_good ||= num_good.to_f / num_players
  end
  
  def all_unknown
    [nil] * num_players
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
  
  def combinations
    @combinations ||= ([:good] * num_good + [:bad] * num_bad).permutations.to_set
  end
  
  private
  
  def player_idx
    @player_idx ||= num_players - MIN_PLAYERS
  end
end
