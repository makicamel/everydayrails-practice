require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "#index" do
    context "as an authorized user" do
      before do
        @user = FactoryBot.create(:user)
      end
      it "responds successfully" do
        sign_in @user
        get :index
        expect(response).to be_success
      end
      it "returns a 200 response" do
        sign_in @user
        get :index
        expect(response).to have_http_status "200"
      end
    end
    context "as a guest" do
      it "returns a 302 response" do
        get :index
        expect(response).to have_http_status "302"
      end
      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
  describe "#show" do
    context "as an authorized user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end
      it "responds  successfully" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to be_success
      end
    end
    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user, email: "tester2@example.com")
        @project = FactoryBot.create(:project, owner: other_user)
      end
      it "redirects to the dashbord" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end
  end
  describe "#create" do
    context "as an authorized user" do
      before do
        @user = FactoryBot.create(:user)
      end
      it "adds a project" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        expect { post :create, params: { project: project_params } }.to change(@user.projects, :count).by(1)
      end
    end
    context "as an unauthorized user" do
      it "returns a 302 status" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to have_http_status "302"
      end
      it "redirects to the sign-in page" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
  describe "#update" do
    context "as an authorized user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end
      it "updates a project" do
        project_params = FactoryBot.attributes_for(:project, name: "New project name")
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq "New project name"
      end
    end
    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user, email: "test2@example.com")
        @project = FactoryBot.create(:project, owner: other_user, name: "Same old name")
      end
      it "does not update the project" do
        sign_in @user
        patch :update, params: { id: @project.id, project: { name: "New project name" } }
        expect(@project.reload.name).to eq "Same old name"
      end
      it "redirects to the dashboard" do
        sign_in @user
        patch :update, params: { id: @project.id, project: { name: "New project name" } }
        expect(response).to redirect_to root_path
      end
    end
    context "as a guest" do
      before do
        user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: user)
      end
      it "returns a 302 status" do
        patch :update, params: { id: @project.id, project: { name: "New project name" } }
        expect(response).to have_http_status "302"
      end
      it "redirects to sign-in page" do
        patch :update, params: { id: @project.id, project: { name: "New project name" } }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
