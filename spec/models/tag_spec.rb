require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe "associations" do
    it { should have_many(:article_tags) }
    it { should have_many(:articles) }
  end
end