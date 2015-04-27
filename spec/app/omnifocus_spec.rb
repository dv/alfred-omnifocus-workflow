require "omnifocus"

RSpec.describe Omnifocus do
  let(:omnifocus) { Omnifocus.new }
  before(:each) do
    omnifocus.activate_if_not_running!
  end

  describe "#projects" do
    it "returns a list of projects" do
      projects = omnifocus.projects

      expect(projects).not_to be_empty
    end
  end

  describe "#contexts" do
    it "returns a list of contexts" do
      contexts = omnifocus.contexts

      expect(contexts).not_to be_empty
    end
  end
end