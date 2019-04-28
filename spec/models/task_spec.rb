require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:project) { FactoryBot.create(:project) }

  it "プロジェクトと名前があれば有効な状態であること" do
    task = Task.new(
      project: project,
      name: "New Task"
    )
    expect(task).to be_valid
  end

  it "プロジェクトがなければ無効な状態であること" do
    task = Task.new(project: nil)
    task.valid?
    expect(task.errors[:project]).to include "must exist"
  end

  it "タスクの名前がなければ無効な状態であること" do
    task = Task.new(name: nil)
    task.valid?
    expect(task.errors[:name]).to include "can't be blank"
  end
end
