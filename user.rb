class User
  attr_accessor :rank, :progress

  def initialize
    @rank, @progress = -8, 0
  end

  def inc_progress(rank)
    raise 'error' if rank.abs > 8
    difference = rank - @rank
    if rank > @rank
      (@rank..rank).to_a.include?(0) && difference -= 1
    end
    difference > 8 && difference = 8
    if difference > 0
      increment = @progress + 10*(difference**2)
    else
      increment = case difference
                    when 0 then @progress + 3
                    when -1 then @progress + 2
                    else @progress
                  end
    end

    @progress = increment % 100

    rank_increment = @rank + (increment / 100)
    @rank = if (@rank..rank_increment).to_a.include?(0)
      rank_increment + 1
    else
      rank_increment
    end
    @rank > 8 && @rank = 8
    @rank == 8 && @progress = 0
  end

end
