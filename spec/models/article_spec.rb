require 'rails_helper'

RSpec.describe Article, type: :model do
  subject {
    described_class.new(title: "Title1")
  }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:article_tags) }
    it { should have_many(:tags) }
    it { should have_many(:comments) }
  end

  context 'validations' do
    context 'with user' do
      let(:user) {
        User.new(username: "User",
          email: "demo@example.com",
          password_digest: "pwd")
      }

      before(:example) do
        user.articles << subject
      end

      it "is valid with valid attributes" do
        expect(subject).to be_valid
      end
    
      it "is not valid without a title" do
        subject.title = nil
        expect(subject).to_not be_valid
      end
    
      it "is not valid with a empty title" do
        subject.title = ""
        expect(subject).to_not be_valid
      end
    
      it "is not valid with a long title (> 20)" do
        subject.title = "123456789012345678901"
        expect(subject).to_not be_valid
      end
    end

    context 'without user' do
      it "is not valid without a user" do
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'relations' do
    it 'has many tags' do
      tag1 = Tag.new(name: "Tag1")
      tag2 = Tag.new(name: "Tag2")
      expect(subject.tags).to be_empty
      subject.tags << [tag1, tag2]
      expect(subject.tags.first).to eql(tag1)
      expect(subject.tags.last).to eql(tag2)
    end

    it 'has many comments' do
      comment1 = Comment.new(comment: "Comment1")
      comment2 = Comment.new(comment: "Comment2")
      expect(subject.comments).to be_empty
      subject.comments << [comment1, comment2]
      expect(subject.comments.first).to eql(comment1)
      expect(subject.comments.last).to eql(comment2)
    end
  end

  describe 'callbacks' do
    let(:article) { described_class.create(title: "The Title 1") }
    it 'should set slug on create' do
      expect(article.slug).to eq("the-title-1")
    end

    it 'should set slug on update' do
      article.update(title: "The Title 2")
      expect(article.slug).to eq("the-title-2")
    end
  end

  describe 'scope' do
    context 'should be able to filter' do
      let(:user1) { 
        User.create(username: "UserArticle1", email: "demoArticle1@example.com", password_digest: "pwd")
      }
      let(:user2) { 
        User.create(username: "UserArticle2", email: "demoArticle2@example.com", password_digest: "pwd")
      }
      let(:article1) {
        described_class.create(title: "Article 1", status: :draft)
      }
      let(:article2) {
        described_class.create(title: "Article 2", status: :pending)
      }
      let(:article3) {
        described_class.create(title: "Article 3", status: :live)
      }
      let(:article4) {
        described_class.create(title: "Article 4")
      }
      let(:tag1) {
        Tag.create(name: "tag1")
      }
      let(:tag2) {
        Tag.create(name: "tag2")
      }

      before(:example) do 
        user1.articles << [article1, article2]
        user2.articles << [article3, article4]
        article1.tags << tag1
        article3.tags << tag2
      end

      it 'by user' do
        articles = described_class.filter_by_user(user1)
        expect(articles.length).to eq(2)
        expect(articles.first.title).to eq("Article 1")
        expect(articles.second.title).to eq("Article 2")
      end

      it 'by status draft' do
        articles = Article.filter_by_status(:draft)
        expect(articles.length).to eq(1)
        expect(articles.first.title).to eq("Article 1")
      end

      it 'by status pending' do
        articles = Article.filter_by_status(:pending)
        expect(articles.length).to eq(1)
        expect(articles.first.title).to eq("Article 2")
      end

      it 'by status live' do
        articles = Article.filter_by_status(:live)
        expect(articles.length).to eq(1)
        expect(articles.first.title).to eq("Article 3")
      end

      it 'by invalid status and return all other' do
        articles = Article.filter_by_status(:any)
        expect(articles.length).to eq(1)
        expect(articles.first.title).to eq("Article 4")
      end

      it 'by tag' do
        articles = Article.filter_by_tag(tag1)
        expect(articles.length).to eq(1)
        expect(articles.first.title).to eq("Article 1")
      end

      it 'by status and user' do
        articles = Article.filter_by_status_and_user(:draft, user1)
        expect(articles.length).to eq(1)
        expect(articles.first.title).to eq("Article 1")
      end
    end
  end

end