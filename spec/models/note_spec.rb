require 'rails_helper'

RSpec.describe Note, type: :model do

  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }

  it "ユーザー、プロジェクト、メッセージがあれば有効な状態であること" do
    note = Note.new(
      message: "This is a sample note.",
      project: project,
      user: user
    )
    expect(note).to be_valid
  end

  it "メッセージがなければ無効な状態であること" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include "can't be blank"
  end

  describe "文字列に一致するメッセージを検索する" do
    let!(:note1) {
      FactoryBot.create(:note,
        message: "First Note, yeah",
        project: project,
        user: user
      )
    }
    let!(:note2) {
      FactoryBot.create(:note,
        message: "Second Note",
        project: project,
        user: user
      )
    }
    let!(:note3) {
      FactoryBot.create(:note,
        message: "Third Note, yeah",
        project: project,
        user: user
      )
    }

    context "一致するメッセージがあるとき" do
      it "検索文字列に一致するメモを返すこと" do
        expect(Note.search("yeah")).to include(note1, note3)
      end
    end

    context "一致するメッセージが1件もないとき" do
      it "空のコレクションを返すこと" do
        expect(Note.search("message")).to be_empty
      end
    end

  end
end
