class PlayerGroup
  attr_reader :players, :num_good
  
  def self.singleton player
    new([player], 1)
  end
  
  def initialize players, num_good
    @players = Set.new(players)
    @num_good = num_good
  end
  
  def - other
    if players > other.players
      diff_players = players - other.players
      diff_good = num_good - other.num_good
    else
      diff_players = players
      diff_good = num_good
    end
    
    PlayerGroup.new(diff_players, diff_good)
  end
  
  def intersect? other
    players.intersect?(other.players)
  end
  
  def singleton?
    players.one?
  end
  
  def prob game_num_good, game_num_bad
    game_num_players = game_num_good + game_num_bad
    game_num_good.choose(num_good) * game_num_bad.choose(num_bad) / game_num_players.choose(num_players).to_f
  end
  
  def num_players
    players.size
  end
  
  def num_bad
    num_players - num_good
  end
  
  def <= other
    players <= other.players
  end
  
  def < other
    players < other.players
  end
  
  def >= other
    players >= other.players
  end
  
  def > other
    players > other.players
  end
  
  def == other
    eql?(other)
  end
  
  def eql? other
    players == other.players && num_good == other.num_good
  end
  
  def hash
    players.hash
  end
  
  def to_s
    "(#{players.map(&:name).join(",")},G=#{num_good})"
  end
end
