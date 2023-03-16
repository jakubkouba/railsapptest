RSpec.describe HelloController, type: :request do
    describe 'GET root' do
        subject { get '/' }

        it { is_expected.to eq 200 }
    end
end