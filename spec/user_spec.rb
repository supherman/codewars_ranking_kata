require_relative '../user'
require 'spec_helper'

describe User do
  it 'starts with a -8 rank' do
    expect(subject.rank).to eq -8
  end

  it 'starts with a zero progress' do
    expect(subject.progress).to eq 0
  end

  it 'responds to inc_progress' do
    expect(subject).to respond_to :inc_progress
  end

  specify do
    subject.inc_progress(1)
    expect(subject.rank).to eq -2
    expect(subject.progress).to eq 40
    subject.inc_progress(1)
    expect(subject.rank).to eq -2
    expect(subject.progress).to eq 80
  end

  describe 'Rank upgrade' do
    context 'Activity of the same rank' do
      it 'earns 3 points' do
        expect{subject.inc_progress(-8)}.to change{subject.progress}.from(0).to(3)
      end
    end

    context 'Activity with rank difference of -1' do
      before do
        subject.rank = -7
      end

      it 'earns 2 points' do
        expect{subject.inc_progress(-8)}.to change{subject.progress}.from(0).to(2)
      end
    end

    context 'Activity with rank difference of -2 or lower' do
      before do
        subject.rank = -6
      end

      it 'earns 0 points' do
        expect{subject.inc_progress(-8)}.to_not change{subject.progress}
      end
    end

    context 'Activity ranked higher' do
      it 'earns 10 * d * d where d equals the difference in ranking between the activity and the user' do
        expect{subject.inc_progress(-7)}.to change{subject.progress}.from(0).to(10)
      end
    end

    context 'When the progress reaches 100' do
      before do
        subject.progress = 99
        subject.inc_progress(-8)
      end

      it "the user's rank is upgraded to the next level" do
        expect(subject.rank).to eq -7
      end

      it "rank will be applied towards the next rank's progress" do
        expect(subject.progress).to eq 2
      end
    end

    context 'User in the top rank' do
      before do
        subject.rank = 8
        subject.progress = 99
      end

      it "doesn't increment rank anymore" do
        expect{subject.inc_progress(8)}.to_not change{subject.rank}
      end
    end

    context 'upgrade rank from -1' do
      before do
        subject.rank = -1
        subject.progress = 99
      end

      it 'there is no zero rank' do
        expect{subject.inc_progress(-1)}.to change{subject.rank}.from(-1).to(1)
      end
    end

    context 'Progress 40, rank 1' do
      before do
        subject.progress = 40
      end

      it 'increments progress to 80' do
        expect{subject.inc_progress(1)}.to change{subject.progress}.from(40).to(80)
      end

      it 'increments rank to -2' do
        expect{subject.inc_progress(1)}.to change{subject.rank}.from(-8).to(-2)
      end
    end

    context 'Progress 0, rank 1' do
      it 'increments progress to 80' do
        expect{subject.inc_progress(1)}.to change{subject.rank}.from(-8).to(-2)
      end
    end

    context 'rank 8' do
      before do
        subject.rank = 8
      end

      it 'should not increment progress anymore' do
        subject.inc_progress(8)
        expect(subject.progress).to eq 0
      end
    end

  end
end
