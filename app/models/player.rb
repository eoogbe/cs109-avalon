class Player < ActiveRecord::Base
  belongs_to :game
  has_and_belongs_to_many :quests
  validates :name, presence: true
  validates :game, presence: true
  validate :name_uniqueness
  
  def prob_good_so_far
    @prob_good_so_far ||= begin
      quests_as_groups = game.quests.flat_map do |quest|
        questors = quest.players
        nonquestors = game.players.where.not(id: questors.ids)
        [PlayerGroup.new(questors, quest.num_successes), PlayerGroup.new(nonquestors, quest.num_fails)]
      end
      puts name
      
      quests_as_set = PlayerGroupSet.new(quests_as_groups)
      prob_quests = quests_as_set.prob(game.num_good, game.num_bad)
      
      good_quests_as_set = quests_as_set & PlayerGroupSet.singleton(self)
      prob_good_quests = good_quests_as_set.prob(game.num_good, game.num_bad)
      
      prob_good_quests / prob_quests
    end
  end
  
  private
  
  def name_uniqueness
    names = game.players.map(&:name)
    errors.add(:name, "must be unique") if names != names.uniq
  end
end
