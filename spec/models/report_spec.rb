describe Report do
  let(:reporter) { FactoryBot.create(:user1) }
  let(:reportee) { FactoryBot.create(:user2) }

  describe 'validation' do
    context 'valid to report user' do
      let(:report) { reportee.reports.new(reporter: reporter) }

      specify { expect(report).to be_valid }
    end

    context 'invalid with self-reporting' do
      let(:report) { reportee.reports.new(reporter: reportee) }

      specify { expect(report).to be_invalid }
    end

    context 'valid to report comment' do
      let(:comment) {
        Comment.create_from!({
          comment_by: reportee.id, comment: 'test', commentable_type: 'moment',
          commentable_id: 1, visibility: 'all'
        })
      }

      let(:report) { comment.reports.new(reporter: reporter) }

      specify { expect(report).to be_valid }
    end

    context 'valid to report with note' do
      let(:report) { reportee.reports.new(reporter: reporter, note: 'test') }

      specify { expect(report).to be_valid }
    end
  end

  describe '#reported_users' do
    it 'returns array of users that have been reported' do
      reportee.reports.create(reporter: reporter)

      result = Report.reported_users

      expect(result.class).to eq(Array)
      expect(result.size).to eq(1)
      expect(result.first).to eq(reportee)
    end

    context 'with an argument' do
      it 'does not return unmatched users' do
        unmatch = reportee.reports.create(reporter: reporter)
        match = reportee.reports.create(reporter: reporter, status: :closed)

        result = Report.reported_users(:closed)

        expect(result.class).to eq(Array)
        expect(result.size).to eq(1)
        expect(result.first).to eq(match.reportee)
      end
    end
  end
end
