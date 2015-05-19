require 'spec_helper'
require 'tictactoe/ai/ab_negamax'

RSpec.describe Tictactoe::Ai::ABNegamax do
  def preferred_nodes(tree)
    negamax = described_class.new(-1, 10)
    strategy = negamax.best_nodes(tree)
    strategy
  end

  def score(tree, depth = 10, depth_reached_score = -10)
    negamax = described_class.new(depth, depth_reached_score)
    negamax.score(tree)
  end

  def leaf(score)
    spy "leaf scored: #{score}", :is_final? => true, :score => score
  end

  def tree(childs)
    spy "tree, childs: #{childs.to_s}", :is_final? => false, :childs => childs
  end

  it 'with one player choice of score 0, the resulting score is 0' do
    root = tree([
      #player choice
      leaf(0)
    ])

    expect(score(root)).to eq(0)
  end

  it 'with one player choice of score -1 for player, the resulting score is -1' do
    root = tree([
      #player choice
      leaf(-1)
    ])

    expect(score(root)).to eq(-1)
  end

  it 'with two player choices of score 0 and 1 for player, the resulting score is 1 (the best for player)' do
    root = tree([
      #player choice
      leaf(1),
      leaf(0),
    ])

    expect(score(root)).to eq(1)
  end

  it 'with one opponnent choice of score 1 for player, the resulting score is 1' do
    root = tree([
      #player choice
      tree([
        #opponent choice
        leaf(1),
      ])
    ])

    expect(score(root)).to eq(1)
  end

  it 'with two opponnent choices of score 0 and 1 for player, it will chose 0 (the worst for player)' do
    root = tree([
      #player choice
      tree([
        #opponent choice
        leaf(1),
        leaf(0),
      ])
    ])

    expect(score(root)).to eq(0)
  end

  it 'with a depth limit of 0 and a score of -10 for the deeper nodes, when provided a single node at depth 1 returns -10' do
    depth = 0
    depth_reached_score = -10

    root = tree([
      #player choice
      leaf(1),
    ])

    expect(score(root, depth, depth_reached_score)).to eq(-10)
  end

  it 'with a depth limit of 1 and a score of -10 for the deeper nodes, when provided a single node at depth 2 returns -10' do
    depth_limit = 1
    depth_reached_score = -10

    root = tree([
      #player choice
      tree([
        #opponent choice
        leaf(1),
      ])
    ])

    expect(score(root, depth_limit, depth_reached_score)).to eq(-10)
  end

  it 'with a depth limit of 2 and a score of -10 for the deeper nodes, when provided a single node of score 1 at depth 2 returns 1' do
    depth_limit = 2
    depth_reached_score = -10

    root = tree([
      #player choice
      tree([
        #opponent choice
        leaf(1),
      ])
    ])

    expect(score(root, depth_limit, depth_reached_score)).to eq(1)
  end

  it 'with a branch that is going to be worse than a previous choice, stops evaluating once it knows' do
    not_evaluated_node = leaf(100)
    root = tree([
      #player choice
      leaf(1),
      tree([
        #opponent choice
        leaf(0),
        not_evaluated_node,
      ])
    ])

    root_score = score(root)

    expect(root_score).to eq(1)
    expect(not_evaluated_node).not_to have_received(:score)
    expect(not_evaluated_node).not_to have_received(:is_leaf?)
  end

  it 'with a branch that is going to be discarded by the opponents choice, stops evaluating once it knows' do
    not_evaluated_node = leaf(-1)
    root = tree([
      #player choice
      tree([
        #opponent choice
        leaf(-1),
        tree([
          #player choice
          leaf(0),
          not_evaluated_node,
        ]),
      ]),
    ])

    score(root)
    expect(not_evaluated_node).not_to have_received(:score)
  end

  it 'with one player choice of score 0, that is the only preferred node' do
    only_option = leaf(0)
    root = tree([
      #player choice
      only_option
    ])

    expect(preferred_nodes(root)).to eq([only_option])
  end

  it 'with two player choices of score 0, those two are the prefered nodes' do
    option1 = leaf(0)
    option2 = leaf(0)
    root = tree([
      #player choice
      option1,
      option2
    ])

    expect(preferred_nodes(root)).to eq([option1, option2])
  end

  it 'with equivalent branches, those are the preferred nodes' do
    option1 = tree([
      #opponent choice
      leaf(0)
    ])
    option2 = tree([
      #opponent choice
      leaf(0)
    ])

    root = tree([
      #player choice
      option1,
      option2
    ])

    expect(preferred_nodes(root)).to eq([option1, option2])
  end
end
