require 'spec_helper'

describe Match do
  describe "setting default date" do
    subject { Match.create }
    let(:occurred_at) { Time.parse("2011-03-27") }
    before { Time.stub(:now).and_return(occurred_at) }
    its(:occurred_at) { should == occurred_at }
  end

  describe "validations" do
    subject { Match.create }
    it { should_not be_valid }
  end

  describe "updating player ranks" do
    let!(:p1) { Player.create(name: "p1") }
    let!(:p2) { Player.create(name: "p2") }
    let!(:p3) { Player.create(name: "p3") }
    let!(:p4) { Player.create(name: "p4") }
    let!(:p5) { Player.create(name: "p5") }
    let!(:establishing_match1) { Match.create(winner: p1.reload, loser: p4.reload) }
    let!(:establishing_match2) { Match.create(winner: p3.reload, loser: p4.reload) }
    let!(:establishing_match3) { Match.create(winner: p2.reload, loser: p1.reload) }

    before do
      Match.order(:id).should == [establishing_match1, establishing_match2, establishing_match3]
      establishing_match1.winner.should == p1
      establishing_match1.loser.should == p4

      p1.reload.should be_active
      p2.reload.should be_active
      p3.reload.should be_active
      p4.reload.should be_active
      p5.reload.should be_inactive

      p1.rank.should == 1
      p2.rank.should == 2
      p3.rank.should == 3
      p4.rank.should == 4
      p5.rank.should be_nil
    end

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
        Player.update_all :active => true
        Match.update_all :occurred_at => 1.day.ago
        players = Player.all.map{|p|[p.name, p.rank]}
        m = Match.create(winner: p4, loser: p1)

        p1.reload.rank.should == 1
        p4.reload.rank.should == 2
        p2.reload.rank.should == 3
        p3.reload.rank.should == 4
      end
    end

    context "when the winner doesn't have a rank yet" do
      it "assigns the correct ranks" do
        Player.update_all :active => true
        Match.create(winner: p5, loser: p2)

        p2.reload.rank.should == 2
        p5.reload.rank.should == 3
        p3.reload.rank.should == 4
        p4.reload.rank.should == 5
      end
    end
  end

  describe "marking players inactive" do
    let!(:p1) { Player.create(name: "foo") }
    let!(:p2) { Player.create(name: "bar") }
    let!(:p3) { Player.create(name: "baz") }
    let!(:p4) { Player.create(name: "quux") }
    let!(:m1) { Match.create(winner: p4, loser: p2, occurred_at: 31.days.ago) }
    let!(:m2) { Match.create(winner: p1, loser: p3, occurred_at: 15.days.ago) }

    it "should mark players as inactive who haven't played a game in the last 30 days" do
      Player.update_all :active => true
      p4.should be_active
      Match.create(winner: p2, loser: p3)
      p1.reload.should be_active
      p2.reload.should be_active
      p3.reload.should be_active
      p4.reload.should be_inactive
    end

    it "should award players who are inactive with Inactive achievement if they don't have it" do
      Player.update_all :active => true
      p4.should be_active
      Match.create(winner: p2, loser: p3)
      p1.reload.should be_active
      p2.reload.should be_active
      p3.reload.should be_active
      p4.reload.should be_inactive
      p4.achievements.map(&:class).should include(Inactive)
    end

    it "should mark players as inactive who have never played a game" do
      Player.update_all :active => true
      new_player = Player.create(name: "no matches")
      new_player.should be_active
      Match.create(winner: p2, loser: p3)
      new_player.reload.should be_inactive
    end

    it "should update other rankings around the newly inactive player" do
      Player.update_all :active => true
      p4.reload.update_attribute :rank, 1
      p2.reload.update_attribute :rank, 2
      p1.reload.update_attribute :rank, 3
      p3.reload.update_attribute :rank, 4

      Match.create(winner: p4, loser: p3)
      p4.reload.rank.should == 1
      p2.reload.rank.should be_nil
      p2.should be_inactive
      p1.reload.rank.should == 2
      p3.reload.rank.should == 3
    end
  end

  describe "reactivating players" do
    let!(:p1) { Player.create(name: "foo") }
    let!(:p2) { Player.create(name: "bar") }

    before do
      p2.update_attributes(rank: nil, active: false)
    end
    it "should reactivate inactive players when they win a match" do
      Match.create(winner: p1, loser: p2)
      p1.reload.should be_active
    end

    it "should reactivate inactive players when the lose a match" do
      Match.create(winner: p2, loser: p1)
      p1.reload.should be_active
    end
  end

  describe "#check_achievements" do
    let!(:p1) { Player.create(name: "foo") }
    let!(:p2) { Player.create(name: "bar") }

    it "should award beginner to correct player(s)" do
      p1.achievements.count.should == 0
      p2.achievements.count.should == 0
      Match.create(winner: p2, loser: p1)
      p1.reload.achievements.map(&:class).should include(Beginner)
      p2.reload.achievements.map(&:class).should include(Beginner)
    end

    it "should award number juan to the correct player" do
      p1.rank.should == 1
      p2.rank.should_not == 1
      p1.achievements.map(&:class).should_not include(NumberJuan)
      p2.achievements.map(&:class).should_not include(NumberJuan)

      Match.create(winner: p2, loser: p1)

      p1.reload.rank.should == 2
      p2.reload.rank.should == 1
      p1.achievements.map(&:class).should_not include(NumberJuan)
      p2.achievements.map(&:class).should include(NumberJuan)
    end

    it "should assign the match to the achievement" do
      m = Match.create(winner: p2, loser: p1)
      p1.reload.achievements.should be_all{|a| a.match.should == m}
    end
  end

  describe "#check_specials" do
    let!(:bobby) { Player.create(name: 'bobby isaacson') }
    let!(:p1) { Player.create(name: 'p1') }

    it "should do something if special is set on achievement" do
      pending "create a special achievement"

      Match.create(winner: p1, loser: bobby, occurred_at: 1.day.ago)
      p1.reload.achievements.map(&:class).should include(SmiteBobby)
      Match.create(winner: bobby, loser: p1)
      p1.reload.achievements.map(&:class).should_not include(SmiteBobby)
    end
  end
end
