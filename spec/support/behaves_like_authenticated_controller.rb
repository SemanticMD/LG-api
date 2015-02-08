RSpec.shared_examples "an authenticated controller" do
  context "unauthenticated" do
    before { sign_out resource }
    subject { request.call }
    it { expect(subject.code).to eq("401") }
  end
end
