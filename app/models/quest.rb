class Quest < ActiveRecord::Base
  belongs_to :game
  has_and_belongs_to_many :players, ->{ order(:id) }
  validates :num_fails, presence: true,
    numericality: { greater_than_or_equal_to: 0,
      less_than_or_equal_to: ->(quest){ quest.game.next_quest_players_count }}
  validates :game, presence: true
  
  def prob
    @prob ||= game.num_good.choose(num_successes) * game.num_bad.choose(num_fails) / game.num_players.choose(num_players).to_f
  end
  
  def prob_given_past player_idx = nil
    return prob unless past.exists?
    
    past_players_known.select do |pk|
      player_idx.nil? || pk[player_idx] != :bad
    end.map do |pk|
      pk[player_idx] = :good if player_idx
    end.reduce(0) do |prob, pk|
      prob + prob_given_players_known(pk)
    end
  end
  
  def prob_given_players_known players_known
    num_good_known = players_known.count(:good)
    num_bad_known = players_known.count(:bad)
    
    num_questors_unknown = players.to_a.count do |player|
      players_known[player.idx].nil?
    end
    
    num_fails_known = players.to_a.count do |player|
      players_known[player.idx] == :bad
    end
    
    num_good_unknown = game.num_good - num_good_known
    num_bad_unknown = game.num_bad - num_bad_known
    num_unknown = num_good_unknown + num_bad_unknown
    
    num_fails_unknown = num_fails - num_fails_known
    
    num_successes_unknown = num_questors_unknown - num_fails_unknown
    #puts "num_unknown", num_unknown
    #puts "num_questors_unknown", num_questors_unknown
    #puts "num_good_unknown", num_good_unknown
    #puts "num_bad_unknown", num_bad_unknown
    #puts "num_successes_unknown", num_successes_unknown
    #puts "num_fails_unknown", num_fails_unknown
    #puts
    num_good_unknown.choose(num_successes_unknown) * num_bad_unknown.choose(num_fails_unknown) / num_unknown.choose(num_questors_unknown).to_f
  end
  
  private
  
  def num_players
    @num_players ||= players.count
  end
  
  def num_successes
    @num_successes ||= num_players - num_fails
  end
  
  def past_players_known
    @past_players_known ||= begin
      prev_combinations = past.exists? ? past.last.past_players_known : game.combinations
      
      prev_combinations.select do |possibility|
        num_fails_possible = players.count do |player|
          possibility[player.idx] == :bad
        end
        
        num_fails_possible == num_fails
      end
    end
  end
  
  def past
    @past ||= game.quests.where("created_at < ?", created_at)
  end
end
