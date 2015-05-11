class ReproducibleRandom
  attr_accessor :sequence, :progress

  def initialize(sequence = 20.times.map{Random.new.rand})
    @sequence = sequence
    @progress = sequence.cycle
  end

  def rand
    progress.next
  end

  def print
    puts "ReproducibleRandom sequence: #{sequence.to_s}"
  end
end
