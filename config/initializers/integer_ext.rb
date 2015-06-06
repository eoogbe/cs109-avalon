# Adapted from http://rosettacode.org/wiki/Combinations_and_permutations#Ruby
class Integer
  def pick k
    if k > 0
      ((self - k + 1)..self).inject(:*)
    elsif k == 0
      1
    else
      0
    end
  end
 
  def choose k
    if k > 0
      pick(k) / (1..k).inject(:*)
    elsif k == 0
      1
    else
      0
    end
  end
end
