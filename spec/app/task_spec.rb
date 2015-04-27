require "task"

RSpec.describe Task do
  describe "#project" do
    it "detects ::shop" do
      task = Task.new("Get milk ::shop")

      expect(task.project).to eq("shop")
    end

    it "detects :shop" do
      task = Task.new("Get milk :shop")

      expect(task.project).to eq("shop")
    end

    it "detects :shop in the middle" do
      task = Task.new("Get :shop milk")

      expect(task.project).to eq("shop")
    end

    it "detects :shop at the start" do
      task = Task.new(":shop Get milk")

      expect(task.project).to eq("shop")
    end

    it "doesn't match on the wrong side" do
      task = Task.new("Listen: Music")

      expect(task.project).to eq(nil)
    end
  end

  describe "#project=" do
    it "appends at the end" do
      task = Task.new("Get milk")
      task.project = "shop"

      expect(task.project).to eq("shop")
      expect(task.to_s).to eq("Get milk ::shop")
    end

    it "replaces existing project" do
      task = Task.new("Get milk :supermarket")
      task.project = "shop"

      expect(task.project).to eq("shop")
      expect(task.to_s).to eq("Get milk ::shop")
    end

    it "removes spaces from task string" do
      task = Task.new("Get milk :shop")
      task.project = "Hello World!"

      expect(task.to_s).to eq("Get milk ::HelloWorld!")
    end

    it "saves as changed" do
      task = Task.new("Get milk")
      task.project = "shop"

      expect(task.project_changed?).to be_truthy
      expect(task.context_changed?).to be_falsy
    end
  end

  describe "#context=" do
    it "appends at the end" do
      task = Task.new("Get milk")
      task.context = "shop"

      expect(task.context).to eq("shop")
      expect(task.to_s).to eq("Get milk @shop")
    end

    it "saves as changed" do
      task = Task.new("Get milk")
      task.context = "shop"

      expect(task.context_changed?).to be_truthy
      expect(task.project_changed?).to be_falsy
    end
  end

  describe "#likely_editing" do
    it "detects context with both" do
      task = Task.new("Get milk ::groceries @shop")

      expect(task.likely_editing?(:context)).to be_truthy
      expect(task.likely_editing?(:project)).to be_falsy
    end

    it "detects project with both" do
      task = Task.new("Get milk @shop ::groceries")

      expect(task.likely_editing?(:project)).to be_truthy
      expect(task.likely_editing?(:context)).to be_falsy
    end

    it "detects context alone" do
      task = Task.new("Get milk @shop")

      expect(task.likely_editing?(:context)).to be_truthy
      expect(task.likely_editing?(:project)).to be_falsy
    end

    it "detects project alone" do
      task = Task.new("Get milk ::groceries")

      expect(task.likely_editing?(:project)).to be_truthy
      expect(task.likely_editing?(:context)).to be_falsy
    end

    it "detects none" do
      task = Task.new("Get milk")

      expect(task.likely_editing?(:project)).to be_falsy
      expect(task.likely_editing?(:context)).to be_falsy
    end

  end
end
