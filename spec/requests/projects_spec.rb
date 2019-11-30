require 'rails_helper'

RSpec.describe "Projects", type: :request do
  context "as an authorized user" do
    before do
      @user = create(:user)
    end
    context "with valid attributes" do
      it "adds a project" do
        project_params = attributes_for(:project, owner: @user)
        sign_in @user
        expect { post projects_path, params: { project: project_params } }.to change(@user.projects, :count).by 1
      end
    end
    context "with invalid attributes" do
      it "does not add a project" do
        project_params = attributes_for(:project, :invalid)
        sign_in @user
        expect { post projects_path, params: { project: project_params } }.not_to change(Project, :count)
      end
    end
  end
end
