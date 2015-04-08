require 'players/ai/ab_minimax'

RSpec.describe ABMinimax do
  def strategy(tree)
    minimax = described_class.new
    strategy = minimax.evaluate(tree)
    strategy
  end

  def leaf(score)
    spy :score => score, :childs => []
  end

  describe 'a leaf node has no strategy possible' do
    it do
      expect(strategy leaf 1)
        .to eq(:score => 1, :options =>[])
    end

    it do
      expect(strategy leaf(-1))
        .to eq(:score => -1, :options => [])
    end

    it do
      expect(strategy leaf 0)
        .to eq(:score => 0, :options => [])                    
    end
  end

  def one_level_tree(*leaves)
    spy :childs => leaves
  end
  
  describe 'a one-branch, one-level tree has its leaf\'s node as the only strategy' do
    it do
      leaf = leaf(1)
      expect(strategy one_level_tree leaf)
        .to eq(:score => 1, :options => [leaf])
    end

    it do
      leaf = leaf(-1)
      expect(strategy one_level_tree leaf)
        .to eq(:score => -1, :options => [leaf])
    end

    it do
      leaf = leaf(0)
      expect(strategy one_level_tree leaf)
        .to eq(:score => 0, :options => [leaf])
    end
  end

  describe 'a two-branches, one-level tree evaluates to the best nodes' do
    it do
      best_leaf = leaf(1)
      expect(strategy one_level_tree best_leaf, leaf(0))
        .to eq(:score => 1, :options => [best_leaf])
    end

    it do
      best_leaf = leaf(0)
      expect(strategy one_level_tree best_leaf, leaf(-1))
        .to eq(:score => 0, :options => [best_leaf])
    end

    it do
      best_leaf = leaf(1)
      expect(strategy one_level_tree leaf(0), best_leaf)
        .to eq(:score => 1, :options => [best_leaf])
    end

    it do
      best_leaf = leaf(0)
      expect(strategy one_level_tree leaf(-1), best_leaf)
        .to eq(:score => 0, :options => [best_leaf])
    end

    it do
      leaf1 = leaf(1)
      leaf2 = leaf(1)
      expect(strategy one_level_tree leaf1, leaf2)
        .to eq(:score => 1, :options => [leaf1, leaf2])
    end
  end
end
