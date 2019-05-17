require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "#index" do

    it "正常にレスポンスを返すこと" do
      get :index
      expect(response).to be_success
    end

    it "status: 200を返すこと" do
      get :index
      expect(response).to have_http_status "200"
    end

  end

  describe "subject sample" do
    # subject(:action) { get :index }
    # it { is_expected.to be_success }
    # it { is_expected.to have_http_status "200" }
    subject { get :index }
    it { is_expected.to be_success }
    it { is_expected.to have_http_status "200" }
    it { expect(subject.status).to eq 200 }
  end

end
