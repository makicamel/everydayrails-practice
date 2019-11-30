require 'rails_helper'

RSpec.describe "ProjectsApi", type: :request do
  it "loads a project" do
    user = create(:user)
    create(:project, name: "New sample project")
    create(:project, name: "Second sample project", owner: user)

    get api_projects_path, params: { user_email: user.email, user_token: user.authentication_token }
    expect(response).to have_http_status 200

    json = JSON.parse(response.body)
    expect(json.length).to eq 1

    project_id = json[0]["id"]
    get api_project_path(project_id), params: { user_email: user.email, user_token: user.authentication_token }
    expect(response).to have_http_status 200

    json = JSON.parse(response.body)
    expect(json["name"]).to eq "Second sample project"
  end
end
