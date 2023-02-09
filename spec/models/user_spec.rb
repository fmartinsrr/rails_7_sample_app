require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    described_class.new(username: "User",
                        email: "user@example.com",
                        password_digest: "pwd")
  }
  
  describe 'validations' do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a username" do
      subject.username = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with a short username (< 2)" do
      subject.username = "a"
      expect(subject).to_not be_valid
    end

    it "is not valid with a long username (> 25)" do
      subject.username = "12345678901234567890123456"
      expect(subject).to_not be_valid
    end

    it "is not valid without a email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with an invalid email" do
      subject.email = "demo"
      expect(subject).to_not be_valid
    end

    it "is not valid with an invalid email alt" do
      subject.email = "demo@demo"
      expect(subject).to_not be_valid
    end

    it "is not valid without a password" do
      subject.password_digest = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'relations' do
    it 'has many articles' do
      article1 = Article.new(title: "Article1")
      article2 = Article.new(title: "Article2")
      expect(subject.articles).to be_empty
      subject.articles << [article1, article2]
      expect(subject.articles.first).to eql(article1)
      expect(subject.articles.last).to eql(article2)
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
    it 'should downcase email address' do
      user = described_class.create(username: "UserE1",
        email: "DEMOE1@EXAMPLE.COM",
        password_digest: "pwd")
      expect(user.email).to eq("demoe1@example.com")
    end
  end
  
  describe 'scopes' do
    let!(:user) { 
      described_class.create(
        username: "UserA",
        email: "demoA@example.com",
        status: :enable,
        password_digest: "pwd")
    }
    let!(:user1) { 
      described_class.create(username: "UserB",
      email: "demoB@example.com",
      password_digest: "pwd",
      last_login: DateTime.now - 5.day) 
    }
    let!(:user2) { 
      described_class.create(username: "UserC",
      email: "demoC@example.com",
      password_digest: "pwd",
      status: :disable,
      last_login: DateTime.now - 10.day) 
    }

    it 'should scope active users' do
      users = described_class.active_users
      expect(users.length).to eq(1)
      expect(users.first.username).to eql("UserA")
    end

    it 'should scope users without login' do
      users = described_class.without_login_since(DateTime.now - 6.day)
      expect(users.length).to eq(1)
      expect(users.first.username).to eq("UserC")
    end
  end

end