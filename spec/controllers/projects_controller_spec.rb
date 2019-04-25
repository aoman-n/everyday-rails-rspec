require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  describe "#index" do

    context "ログイン済みのユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
      end

      it "正常にレスポンスを返すこと" do
        sign_in @user
        get :index
        expect(response).to be_success
      end

      it "status: 200を返すこと" do
        sign_in @user
        get :index
        expect(response).to have_http_status "200"
      end
    end

    context "ゲストとして" do
      it "302を返すこと" do
        get :index
        expect(response).to have_http_status "302"
      end

      it "ログイン画面にリダイレクトすること" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#show" do
    context "プロジェクトのオーナーのユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "レスポンスがsuccessであること" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to be_success
      end
    end

    context "別のユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it "トップ画面にリダイレクトすること" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#cerate" do
    before do
      @user = FactoryBot.create(:user)
    end

    context "ログイン済みのユーザーとして" do
      before do
        @project_params = FactoryBot.attributes_for(:project)
      end

      context "有効な値の場合" do
        it "プロジェクトを追加出来ること" do
          sign_in @user
          expect{
            post :create, params: { project: @project_params }
          }.to change{@user.projects.count}.by(1)
        end
      end

      context "無効な値の場合" do
        it "プロジェクトを追加出来ないこと" do
          invalid_project_params = FactoryBot.attributes_for(:project, :invalid)
          sign_in @user
          expect{
            post :create, params: { project: invalid_project_params }
          }.to_not change{@user.projects.count}
        end
      end
    end

    context "ゲストとして" do
      it "status: 302を返すこと" do
        post :create, params: { project: @project_params }
        expect(response).to have_http_status "302"
      end

      it "トップにリダイレクトすること" do
        post :create, params: { project: @project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#update" do
    context "プロジェクトのオーナーとして" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "projectを更新が出来ること" do
        project_params = FactoryBot.attributes_for(:project, name: "New Project Name")
        sign_in @user
        patch :update, params: { id: @project.id , project: project_params }
        expect(@project.reload.name).to eq "New Project Name"
      end
    end

    context "プロジェクトのオーナー以外のユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(
          :project,
          name: "Old Project Name",
          owner: other_user
        )
      end

      it "プロジェクトが更新されないこと" do
        project_params = FactoryBot.attributes_for(:project, name: "New Project Name")
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq "Old Project Name"
      end

      it "ルートURLにリダイレクトすること" do
        project_params = FactoryBot.attributes_for(:project, name: "New Project Name")
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to root_path
      end
    end

    context "ゲストとして" do
      before do
        @project = FactoryBot.create(:project)
      end

      it "status: 302を返すこと" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#destroy" do
    context "プロジェクトのオーナーとして" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "プロジェクトを削除出来ること" do
        sign_in @user
        expect{
          delete :destroy, params: { id: @project.id }
        }.to change{@user.projects.count}.by(-1)
      end
    end

    context "プロジェクトのオーナー以外のユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it "status: 302を返すこと" do
        sign_in @user
        delete :destroy, params: { id: @project.id }
        expect(response).to have_http_status "302"
      end

      it "ルートURLにリダイレクトすること" do
        sign_in @user
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end

    context "ゲストとして" do
      before do
        @project = FactoryBot.create(:project)
      end

      it "status: 302を返すこと" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to have_http_status "302"
      end

      it "ログイン画面にリダイレクトすること" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

end
