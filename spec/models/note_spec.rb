require 'rails_helper'

RSpec.describe Note, type: :model do
  before do
    # 全体の前処理
    @user = User.create(
      first_name:"Joe",
      last_name: "Tester",
      email: "joetester@example.com",
      password: "dottle-nouveau-pavilion-tights-furze",
    )
    @project = @user.projects.create(
      name: "Test Project",
    )
  end

  it "ユーザー、プロジェクト、メッセージがあれば有効な状態であること" do
    note = Note.new(
      message: "This is a sample note.",
      project: @project,
      user: @user
    )
    expect(note).to be_valid
  end

  it "メッセージがなければ無効な状態であること" do
    note = Note.new(
      message: "",
      project: @project,
      user: @user
    )
    expect(note).to be_invalid
  end

  describe "文字列に一致するメッセージを検索する" do

    before do
      @note1 = @project.notes.create(
        message: "This is the first note.",
        user: @user,
      )
      @note2 = @project.notes.create(
        message: "This is the second note.",
        user: @user,
      )
      @note3 = @project.notes.create(
        message: "First, preheat the oven.",
        user: @user,
      )
    end

    context "一致するメッセージがあるとき" do
      it "検索文字列に一致するメモを返すこと" do
        expect(Note.search("first")).to include(@note1, @note3)
      end
    end

    context "一致するメッセージが1件もないとき" do
      it "空のコレクションを返すこと" do
        expect(Note.search("message")).to be_empty
      end
    end

  end
end
