require 'rails_helper'

RSpec.describe TasksController, type: :controller do

  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project, owner: @user)
    @task = @project.tasks.create!(name: "Test Task")
  end

  describe "#show" do
    
  end

end
