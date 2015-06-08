class Player < ActiveRecord::Base
  belongs_to :game
  has_and_belongs_to_many :quests
  validates :name, presence: true
  validates :game, presence: true
  validate :name_uniqueness
  
  def prob_good_so_far
    @prob_good_so_far ||= begin
      quests_as_set = game.quests.map do |quest|
        questors = quest.players
        questors_group = PlayerGroup.new(questors, quest.num_successes)
        
        nonquestors = game.players.where.not(id: questors.ids)
        num_good_nonquestors = game.num_good - quest.num_successes
        nonquestors_group = PlayerGroup.new(nonquestors, num_good_nonquestors)
        
        PlayerGroupSet.new([questors_group, nonquestors_group])
      end.reduce(:&)
      
      prob_quests = quests_as_set.prob(game.num_good, game.num_bad)
      
      good_quests_as_set = quests_as_set & PlayerGroupSet.singleton(self)
      prob_good_quests = good_quests_as_set.prob(game.num_good, game.num_bad)
      
      prob_good_quests / prob_quests
    end
  end
  
  def other_players
    @other_players ||= game.players.where.not(id: id)
  end
  
  private
  
  def name_uniqueness
    errors.add(:name, "must be unique") if game.players.map(&:name).count(name) > 1
  end
end
