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
    
    loop do
      subgroups_found = 0
      union = union.flat_map do |pg1|
        subgroups = union.select do |pg2|
          pg1 > pg2
        end
        
        if subgroups.present?
          subgroups_found += 1
          subgroups.map do |pg2, _|
            pg1 - pg2
          end
        else
          pg1
        end
      end
      break if subgroups_found == 0
    end
    
    self.class.new(union)
  end
  alias_method :intersect, :&
  
  def delete player_group
    player_groups.delete(player_group)
  end
  
  def impossible?
    @impossible ||= player_groups.any? do |pg1|
      player_groups.find do |pg2|
        pg1.players == pg2.players && pg1.num_good != pg2.num_good
      end
    end
  end
  
  def disjoint?
    @disjoint ||= player_groups.none? do |pg1|
      player_groups.find {|pg2| pg1 != pg2 && pg1.intersect?(pg2) }
    end
  end
  
  def prob num_good, num_bad
    if impossible?
      0
    elsif disjoint?
      num_good_left = num_good
      num_bad_left = num_bad
      player_groups.reduce(1) do |p, player_group|
        step = p * player_group.prob(num_good_left, num_bad_left)
        num_good_left -= player_group.num_good
        num_bad_left -= player_group.num_bad
        step
      end
    else
      num_players = num_good + num_bad
      prob_good = num_good.to_f / num_players
      split_group = player_groups.find do |player_group|
        !player_group.singleton?
      end
      
      conditional_probs = split_group.players.reduce(0) do |p, player|
        conditional_set = intersect(self.class.singleton(player))
        if conditional_set.impossible?
          p
        else
          conditional_set.delete(PlayerGroup.singleton(player))
          p + conditional_set.prob(num_good - 1, num_bad)
        end
      end
      
      conditional_probs * prob_good
    end
  end
  
  def to_s
    "<#{player_groups.map(&:to_s).join("; ")}>"
  end
end
