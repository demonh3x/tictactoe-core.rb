require 'players/ai/ab_minimax'

RSpec.describe ABMinimax do
  def strategy(tree)
    minimax = described_class.new(-1)
    strategy = minimax.evaluate(tree)
    strategy
  end

  def leaf(score)
    spy "leaf scored: #{score}", :childs => [], :score => score
  end

  describe 'a leaf node has no strategy possible' do
    it do
      expect(strategy leaf 1)
        .to eq([])
    end

    it do
      expect(strategy leaf(-1))
        .to eq([])
    end

    it do
      expect(strategy leaf 0)
        .to eq([])                    
    end
  end

  def tree(leaves)
    spy "tree, childs: #{leaves.to_s}", :childs => leaves
  end
  
  describe 'a one-branch, one-level tree has its leaf\'s node as the only strategy' do
    it do
      leaf = leaf(1)
      expect(strategy tree [leaf])
        .to eq([leaf])
    end

    it do
      leaf = leaf(-1)
      expect(strategy tree [leaf])
        .to eq([leaf])
    end

    it do
      leaf = leaf(0)
      expect(strategy tree [leaf])
        .to eq([leaf])
    end
  end

  describe 'a one-level tree evaluates to the best nodes' do
    it do
      best_leaf = leaf(1)
      expect(strategy tree [best_leaf, leaf(0)])
        .to eq([best_leaf])
    end

    it do
      best_leaf = leaf(0)
      expect(strategy tree [best_leaf, leaf(-1)])
        .to eq([best_leaf])
    end

    it do
      best_leaf = leaf(1)
      expect(strategy tree [leaf(0), best_leaf])
        .to eq([best_leaf])
    end

    it do
      best_leaf = leaf(0)
      expect(strategy tree [leaf(-1), best_leaf])
        .to eq([best_leaf])
    end

    it do
      leaf1 = leaf(1)
      leaf2 = leaf(1)
      expect(strategy tree [leaf1, leaf2])
        .to eq([leaf1, leaf2])
    end

    it do
      leaf2 = leaf(1)
      leaf3 = leaf(1)
      expect(strategy tree [leaf(0), leaf2, leaf3])
        .to eq([leaf2, leaf3])
    end

    it do
      leaf1 = leaf(1)
      leaf3 = leaf(1)
      expect(strategy tree [leaf1, leaf(0), leaf3])
        .to eq([leaf1, leaf3])
    end
  end
end
