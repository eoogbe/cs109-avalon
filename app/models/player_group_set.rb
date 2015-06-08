class PlayerGroupSet
  attr_reader :player_groups
  
  def self.singleton player
    new([PlayerGroup.singleton(player)])
  end
  
  def initialize player_groups
    @player_groups = Set.new(player_groups)
  end
  
  def & other
    union = player_groups | other.player_groups
    
    union.flat_map do |pg1|
      union.map do |pg2|
        pg1 == pg2 ? pg1 : pg1 - pg2
      end
    end
    
    self.class.new(union)
  end
  
  def without group
    conditional_groups = player_groups.map do |player_group|
      player_group - group
    end
    
    self.class.new(conditional_groups)
  end
  
  def disjoint?
    @disjoint ||= player_groups.none? do |pg1|
      player_groups.find {|pg2| pg1 != pg2 && pg1.intersect?(pg2) }
    end
  end
  
  def prob num_good, num_bad
    if disjoint?
      puts "disjoint"
      num_good_left = num_good
      num_bad_left = num_bad
      player_groups.reduce(1) do |p, player_group|
        step = p * player_group.prob(num_good_left, num_bad_left)
        num_good_left -= player_group.num_good
        num_bad_left -= player_group.num_bad
        step
      end
    else
      puts "conditional"
      num_players = num_good + num_bad
      prob_good = num_good.to_f / num_players
      
      conditional_probs = player_groups.first.players.reduce(0) do |p, player|
        singleton_group = PlayerGroup.singleton(player)
        conditional_set = without(singleton_group)
        p + conditional_set.prob(num_good - 1, num_bad)
      end
      
      conditional_probs * prob_good
    end
  end
  
  def to_s
    "<#{player_groups.join("; ")}>"
  end
end
