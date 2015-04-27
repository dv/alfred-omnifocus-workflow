require "task_generator"

RSpec.describe TaskGenerator do
  let(:projects) { ["sandwich", "supermarket", "diy"] }
  let(:contexts) { projects }

  it "generates a task for each project" do
    generator = TaskGenerator.new("Get milk")
    generator.projects = projects

    tasks = generator.tasks.map(&:to_s)

    expect(tasks).to eq([
      "Get milk",
      "Get milk ::sandwich",
      "Get milk ::supermarket",
      "Get milk ::diy"
    ])
  end

  it "autocompletes projects" do
    generator = TaskGenerator.new("Get milk :s")
    generator.projects = projects

    tasks = generator.tasks.map(&:to_s)

    expect(tasks).to eq([
      "Get milk ::sandwich",
      "Get milk ::supermarket"
    ])
  end

  it "fuzzy matches projects" do
    generator = TaskGenerator.new("Get milk :sa")
    generator.projects = projects

    tasks = generator.tasks.map(&:to_s)

    expect(tasks).to eq([
      "Get milk ::sandwich",
      "Get milk ::supermarket"
    ])
  end
end
