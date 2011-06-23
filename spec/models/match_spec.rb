require 'spec_helper'

describe Match do
  describe "setting default date" do
    subject { Match.create }
    let(:occured_at) { Time.parse("2011-03-27") }
    before { Time.stub(:now).and_return(occured_at) }
    its(:occured_at) { should == occured_at }
  end

  describe "validations" do
    subject { Match.create }
    it { should_not be_valid }
  end

  describe "updating player ranks" do
    let!(:p1) { Player.create(name: "p1", rank: 1)}
    let!(:p2) { Player.create(name: "p2", rank: 2)}
    let!(:p3) { Player.create(name: "p3", rank: 3)}
    let!(:p4) { Player.create(name: "p4", rank: 4)}
    let!(:p5) { Player.create(name: "p5", rank: nil)}

    context "when the players are next to each other" do
      it "should update those players ranks" do
        Match.create(winner: p3, loser: p2)

        p3.reload.rank.should == 2
        p2.reload.rank.should == 3
      end
    end

    context "when the winner moves over a single person" do
      it "should update the ranks correctly" do
        Match.create(winner: p3, loser: p1)

        p1.reload.rank.should == 1
        p3.reload.rank.should == 2
        p2.reload.rank.should == 3
      end
    end

    context "moving halfway to the loser" do
      it "should update intermediary players correctly" do
        Match.create(winner: p4, loser: p1)

        p1.reload.rank.should == 1
        p4.reload.rank.should == 2
        p2.reload.rank.should == 3
        p3.reload.rank.should == 4
      end
    end

    context "when the winner doesn't have a rank yet" do
      it "assigns the correct ranks" do
        Match.create(winner: p5, loser: p2)

        p2.reload.rank.should == 2
        p5.reload.rank.should == 3
        p3.reload.rank.should == 4
        p4.reload.rank.should == 5
      end
    end

    context "when no players have ranks yet" do
      before do
        Player.update_all :rank => nil
      end

      it "should assign the winner to be rank 1 and the loser to rank 2" do
        Match.create(winner: p2, loser: p3)

        p2.reload.rank.should == 1
        p3.reload.rank.should == 2
      end
    end

    context "when other players have ranks, but not the loser does not" do
      it "should not update ranks for the players in this match" do
        Match.create(winner: p4, loser: p5)

        p4.reload.rank.should == 4
        p5.reload.rank.should be_nil
      end
    end
  end
end
