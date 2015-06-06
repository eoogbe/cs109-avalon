class Player < ActiveRecord::Base
  belongs_to :game
  has_and_belongs_to_many :quests
  validates :name, presence: true
  validates :game, presence: true
  validate :name_uniqueness
  
  def prob_good_so_far
    puts name
    @prob_good_so_far ||= prob_good_given_quests(game.quests)
  end
  
  def prob_good_given_quests quests
    prob_good_quests = quests.reduce(game.prob_good) do |prob, quest|
      prob * quest.prob_given_past(idx)
    end
    
    prob_quests = quests.reduce(1) do |prob, quest|
      puts "quest prob_given_past", quest.prob_given_past
      prob * quest.prob_given_past
    end
    
    puts "prob_good_quests", prob_good_quests
    puts "prob_quests", prob_quests
    
    prob_good_quests / prob_quests
  end
  
  def idx
    @idx ||= game.players.index(self)
  end
  
  private
  
  def name_uniqueness
    names = game.players.map(&:name)
    errors.add(:name, "must be unique") if names != names.uniq
  end
end
