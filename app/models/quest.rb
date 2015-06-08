class Quest < ActiveRecord::Base
  belongs_to :game
  has_and_belongs_to_many :players, ->{ order(:id) }
  validates :num_fails, presence: true,
    numericality: { greater_than_or_equal_to: 0,
      less_than_or_equal_to: ->(quest){ quest.game.next_quest_players_count }}
  validates :game, presence: true
  
  def num_successes
    @num_successes ||= num_players - num_fails
  end
  
  private
  
  def num_players
    @num_players ||= players.count
  end
end
