require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, name: "Test Project", owner: user) }

  scenario "ユーザーは新しいプロジェクトを作成する" do
    sign_in user
    visit root_path

    expect {
      click_link "New Project"
      input_project("Test Project", "Trying out Capybara")
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  scenario "ユーザーはプロジェクトを編集する" do
    project
    sign_in user
    go_to_project(project.name)

    click_link "Edit"
    input_project("Update name", "Update description")
    click_button "Update Project"

    expect(project.reload.name).to eq "Update name"
  end

  def go_to_project(name)
    visit root_path
    click_link name
  end

  def input_project(name, description)
    fill_in "Name", with: name
    fill_in "Description", with: description
  end

end
