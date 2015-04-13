require 'players/ai/ab_minimax'

RSpec.describe ABMinimax do
  def strategy(tree)
    minimax = described_class.new(-1, 10)
    strategy = minimax.evaluate(tree)
    strategy
  end

  def leaf(score)
    spy "leaf scored: #{score}", :childs => [], :score => score
  end

  describe 'given a leaf node' do
    describe 'there is no strategy possible' do
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
  end

  def tree(childs)
    spy "tree, childs: #{childs.to_s}", :childs => childs
  end
  
  describe 'given a one-leaf one-level tree' do
    it 'does not ask the root for the score' do
      root = tree [leaf(1)]
      strategy root
      expect(root).not_to have_received(:score)
    end

    describe 'has that leaf as the only strategy' do
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
  end

  describe 'given a multiple-leaves one-level tree' do
    describe 'chooses the best leaves' do
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

  describe 'given a two-level one-leaf tree' do
    it 'does not ask the subtree for the score' do
      subtree = tree [leaf(1)]
      strategy tree [subtree]
      expect(subtree).not_to have_received(:score)
    end

    it do
      subtree = tree [leaf(1)]
      expect(strategy tree [subtree])
      .to eq([subtree])
    end
  end

  describe 'given complex tree' do
    describe 'chooses the best option even if it is immediate' do
      it do
        best_option = leaf(1)
        root = tree([
          #my choice
          best_option,
          tree([
            #other's choice
            leaf(0)
          ]),
        ])

        expect(strategy root)
        .to eq([best_option])
      end

      it do
        best_option = leaf(1)
        root = tree([
          #my choice
          tree([
            #other's choice
            leaf(0)
          ]),
          best_option,
        ])

        expect(strategy root)
        .to eq([best_option])
      end
    end

    describe 'chooses the best option even if it is one-level deep' do
      it do
        best_option = tree([
          #other's choice
          leaf(1)
        ])
        root = tree([
          #my choice
          leaf(0),
          best_option,
        ])

        expect(strategy root)
        .to eq([best_option])
      end

      it do
        best_option = tree([
          #other's choice
          leaf(1)
        ])
        root = tree([
          #my choice
          best_option,
          leaf(0),
        ])

        expect(strategy root)
        .to eq([best_option])
      end
    end

    describe 'chooses equivalent options even if they are at different levels' do
      it do
        option1 = tree([
          #other's choice
          leaf(1)
        ])
        option2 = leaf(1)
        root = tree([
          #my choice
          option1,
          option2,
        ])

        expect(strategy root)
        .to eq([option1, option2])
      end

      it do
        option1 = tree([
          #other's choice
          leaf(0)
        ])
        option2 = leaf(0)
        root = tree([
          #my choice
          option1,
          option2,
        ])

        expect(strategy root)
        .to eq([option1, option2])
      end
    end

    describe 'assumes the opponent chooses the worst option' do
      it do
        best_option = leaf(0)
        root = tree([
          #my choice
          best_option,
          tree([
            #other's choice
            leaf(1),
            leaf(-1),
          ]),
        ])

        expect(strategy root)
        .to eq([best_option])
      end

      it do
        best_option = tree([
          #other's choice
          leaf(0),
          leaf(1),
        ])
        root = tree([
          #my choice
          leaf(-1),
          best_option,
        ])

        expect(strategy root)
        .to eq([best_option])
      end

      it do
        best_option = leaf(0)
        root = tree([
          #my choice
          best_option,
          tree([
            #other's choice
            leaf(1),
            leaf(1),
            leaf(-1),
          ]),
        ])

        expect(strategy root)
        .to eq([best_option])
      end
    end

    describe 'stops evaluating when the branch is going to be discarded' do
      it do
        not_evaluated_node = leaf(-1)
        root = tree([
          #my choice
          leaf(1),
          tree([
            #other's choice
            leaf(0),
            not_evaluated_node,
          ]),
        ])

        strategy root
        expect(not_evaluated_node).not_to have_received(:score)
      end

      it do
        not_evaluated_node = leaf(1)
        root = tree([
          #my choice
          leaf(0),
          tree([
            #other's choice
            leaf(-1),
            not_evaluated_node,
          ]),
        ])

        strategy root
        expect(not_evaluated_node).not_to have_received(:score)
      end

      it do
        evaluated_node = leaf(-1)
        root = tree([
          #my choice
          leaf(1),
          tree([
            #other's choice
            leaf(1),
            evaluated_node,
          ]),
        ])

        strategy root
        expect(evaluated_node).to have_received(:score)
      end
    end

    describe 'stops evaluating when the opponent has the possibility to choose the minimum score' do
      it do
        not_evaluated_node = leaf(0)
        root = tree([
          #my choice
          leaf(-1),
          tree([
            #other's choice
            leaf(-1),
            not_evaluated_node,
          ]),
        ])

        strategy root
        expect(not_evaluated_node).not_to have_received(:score)
      end
    end

    describe 'given tree-level deep tree with only maximizing choices' do
      it 'goes in depth until the leaves' do
        last_leaf = leaf(-1)
        root = tree([
          # my choice
          leaf(0),
          tree([
            #other's choice
            tree([
              #my choice
              leaf(1),
              last_leaf,
            ])
          ]),
        ])

        strategy root
        expect(last_leaf).to have_received(:score)
      end

      it 'and a better option at the last level, chooses it' do
        best_option = tree([
          #other's choice
          tree([
            #my choice
            leaf(1)
          ])
        ])

        root = tree([
          #my choice
          leaf(-1),
          best_option,
        ])

        expect(strategy root).to eq([best_option])
      end

      it 'assumes the opponent is going to minimize my winnings' do
        best_option = leaf(0)

        root = tree([
          #my choice
          tree([
            #other's choice
            tree([
              #my choice
              leaf(-1),
            ]),
            tree([
              #my choice
              leaf(1),
            ])
          ]),
          best_option,
        ])

        expect(strategy root).to eq([best_option])
      end
    end

    describe 'given a depth limit' do
      describe 'supposes that the deeper trees have the minimum score possible' do
        it do
          evaluated_leaf = leaf(-1)
          not_evaluated_leaf = leaf(1)
          options_perceived_as_equivalent = [
            #depth 0
            evaluated_leaf,
            tree([
              #depth 1
              not_evaluated_leaf
            ])
          ]

          root = tree(options_perceived_as_equivalent)

          minimax = described_class.new(-1, 0)
          expect(minimax.evaluate root).to eq(options_perceived_as_equivalent)
          expect(evaluated_leaf).to have_received(:score)
          expect(not_evaluated_leaf).not_to have_received(:score)
        end
      end
    end
  end
end
